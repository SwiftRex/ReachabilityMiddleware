import Combine
import Foundation
import Network

extension NWPathMonitor {
    /// Publisher for NWPathMonitor, emitting NWPath for every pathUpdateHandler event. It never fails.
    /// Important: it doesn't respect the demand, it's used only in this middleware that asks for unlimited demand.
    public var publisher: NWPathMonitorPublisher {
        NWPathMonitorPublisher(pathMonitor: self)
    }
}

/// Publisher for NWPathMonitor, emitting NWPath for every pathUpdateHandler event. It never fails.
/// Important: it doesn't respect the demand, it's used only in this middleware that asks for unlimited demand.
public struct NWPathMonitorPublisher: Publisher {
    public typealias Output = NWPath
    public typealias Failure = Never

    private let pathMonitor: NWPathMonitor

    init(pathMonitor: NWPathMonitor) {
        self.pathMonitor = pathMonitor
    }

    public func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, NWPath == S.Input {
        let subscription = Subscription(subscriber: subscriber, pathMonitor: pathMonitor)
        subscriber.receive(subscription: subscription)
    }

    private class Subscription<S: Subscriber>: Combine.Subscription where S.Input == NWPath, S.Failure == Never {
        private var subscriber: S?
        private let pathMonitor: NWPathMonitor
        private let lock = NSRecursiveLock()
        private var isRunning = false

        init(subscriber: S, pathMonitor: NWPathMonitor) {
            self.subscriber = subscriber
            self.pathMonitor = pathMonitor
        }

        func request(_ demand: Subscribers.Demand) {
            guard !isRunning, demand > 0 else { return }

            lock.lock()
            defer { lock.unlock() }

            guard !isRunning else { return }
            isRunning = true
            start()
        }

        func cancel() {
            pathMonitor.cancel()
            isRunning = false
            subscriber = nil
        }

        private func start() {
            pathMonitor.pathUpdateHandler = { [weak self] path in
                guard let self = self else { return }
                _ = self.subscriber?.receive(path)
            }
            pathMonitor.start(queue: .main)
        }
    }
}
