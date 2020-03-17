import Foundation
import Network
import SwiftRex

public final class ReachabilityMiddleware: Middleware {
    public typealias InputActionType = ReachabilityEvent
    public typealias OutputActionType = ReachabilityEvent
    public typealias StateType = ReachabilityState
    private let monitor: NWPathMonitor
    private var getState: GetState<ReachabilityState>?
    private var output: AnyActionHandler<ReachabilityEvent>?

    public init(monitorOnly: ConnectedInterface = .none) {
        switch monitorOnly {
        case .cellular:
            self.monitor = NWPathMonitor(requiredInterfaceType: .cellular)
        case .wifi:
            self.monitor = NWPathMonitor(requiredInterfaceType: .wifi)
        case .wired:
            self.monitor = NWPathMonitor(requiredInterfaceType: .wiredEthernet)
        default:
            self.monitor = NWPathMonitor()
        }
    }

    public func receiveContext(getState: @escaping GetState<ReachabilityState>, output: AnyActionHandler<ReachabilityEvent>) {
        self.getState = getState
        self.output = output
    }

    public func handle(action: ReachabilityEvent, from dispatcher: ActionSource, afterReducer: inout AfterReducer) {
        switch action {
        case .startMonitoring:
            monitor.pathUpdateHandler = { [weak self] path in
                guard let self = self,
                    let getState = self.getState,
                    let output = self.output else { return }

                if path.usesInterfaceType(.wiredEthernet) {
                    output.dispatch(.connectedToWired)
                } else if path.usesInterfaceType(.wifi) {
                    output.dispatch(.connectedToWifi)
                } else if path.usesInterfaceType(.cellular) {
                    output.dispatch(.connectedToCellular)
                } else {
                    output.dispatch(.gotOffline)
                }

                if path.isExpensive != getState().isExpensive {
                    output.dispatch(path.isExpensive ? .becameExpensive : .becameCheap)
                }

                if path.isConstrained != getState().isConstrained {
                    output.dispatch(path.isConstrained ? .becameConstrained : .becameUnconstrained)
                }
            }
        case .stopMonitoring:
            monitor.cancel()
        default: break
        }
    }
}
