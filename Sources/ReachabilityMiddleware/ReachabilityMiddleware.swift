import CombineRex
import SwiftRex

extension EffectMiddleware
where InputActionType == ReachabilityEvent,
      OutputActionType == ReachabilityEvent,
      StateType == ReachabilityState,
      Dependencies == ReachabilityMiddlewareDependencies {

    public static var reachability: MiddlewareReader<ReachabilityMiddlewareDependencies, EffectMiddleware> {
        EffectMiddleware.onAction { action, dispatcher, state in
            let cancellationToken = "nwPathMonitoringToken"
            switch action {
            case .startMonitoring:
                return Effect(token: cancellationToken) { context in
                    context
                        .dependencies
                        .pathMonitor()
                        .map { path in
                            [
                                send(event: .connectedToWired,
                                     when: path.usesInterfaceType(.wiredEthernet),
                                     previously: \.connectivity != .wired,
                                     state: state),

                                send(event: .connectedToWifi,
                                     when: path.usesInterfaceType(.wifi),
                                     previously: \.connectivity != .wifi,
                                     state: state),

                                send(event: .connectedToCellular,
                                     when: path.usesInterfaceType(.cellular),
                                     previously: \.connectivity != .cellular,
                                     state: state),

                                send(event: .gotOffline,
                                     when: ![.wiredEthernet, .wifi, .cellular].contains(where: path.usesInterfaceType),
                                     previously: \.connectivity != .none,
                                     state: state),

                                send(event: .becameExpensive,
                                     when: path.isExpensive,
                                     previously: \.isExpensive != true,
                                     state: state),

                                send(event: .becameCheap,
                                     when: !path.isExpensive,
                                     previously: \.isExpensive == true,
                                     state: state),

                                send(event: .becameConstrained,
                                     when: path.isConstrained,
                                     previously: \.isConstrained != true,
                                     state: state),

                                send(event: .becameUnconstrained,
                                     when: !path.isConstrained,
                                     previously: \.isConstrained == true,
                                     state: state)
                            ]
                            .compactMap { $0 }
                            .publisher
                        }
                        .switchToLatest()
                }

            case .stopMonitoring:
                return .toCancel(cancellationToken)

            default:
                return .doNothing
            }
        }
    }
}

private func send(
    event: ReachabilityEvent,
    when currentCondition: Bool,
    previously: (ReachabilityState) -> Bool,
    state getState: () -> ReachabilityState,
    file: String = #file,
    function: String = #function,
    line: UInt = #line
) -> DispatchedAction<ReachabilityEvent>? {
    guard currentCondition, previously(getState()) else { return nil }
    return DispatchedAction(event, dispatcher: .init(file: file, function: function, line: line, info: nil))
}

extension KeyPath where Value: Equatable {
    static func ==(key: KeyPath<Root, Value>, value: Value) -> (Root) -> Bool {
        { comparedRoot in
            comparedRoot[keyPath: key] == value
        }
    }

    static func !=(key: KeyPath<Root, Value>, value: Value) -> (Root) -> Bool {
        { comparedRoot in
            comparedRoot[keyPath: key] != value
        }
    }
}
