import Combine
import Network

public struct ReachabilityMiddlewareDependencies {
    public let pathMonitor: () -> AnyPublisher<NWPathProtocol, Never>
    public init(pathMonitor: @escaping () -> AnyPublisher<NWPathProtocol, Never>) {
        self.pathMonitor = pathMonitor
    }

    @available(macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0, *)
    public static func production(prohibitedInterfaceTypes: [NWInterface.InterfaceType]) -> ReachabilityMiddlewareDependencies {
        ReachabilityMiddlewareDependencies { NWPathMonitor(prohibitedInterfaceTypes: prohibitedInterfaceTypes).publisher.eraseToAnyPublisher() }
    }

    public static func production() -> ReachabilityMiddlewareDependencies {
        ReachabilityMiddlewareDependencies { NWPathMonitor().publisher.eraseToAnyPublisher() }
    }

    public static func production(requiredInterfaceType: NWInterface.InterfaceType) -> ReachabilityMiddlewareDependencies {
        ReachabilityMiddlewareDependencies { NWPathMonitor(requiredInterfaceType: requiredInterfaceType).publisher.eraseToAnyPublisher() }
    }

    #if DEBUG
    public static func forTests(subject: PassthroughSubject<NWPathProtocol, Never>) -> ReachabilityMiddlewareDependencies {
        ReachabilityMiddlewareDependencies { subject.eraseToAnyPublisher() }
    }
    #endif
}
