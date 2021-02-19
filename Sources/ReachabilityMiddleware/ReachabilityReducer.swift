import Foundation
import SwiftRex

extension Reducer where ActionType == ReachabilityEvent, StateType == ReachabilityState {
    public static let reachability = Reducer.reduce { action, state in
        switch action {
        case .connectedToWifi:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: .wifi,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .connectedToWired:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: .wired,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .connectedToCellular:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: .cellular,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .gotOffline:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: .none,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .becameCheap:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: false,
                isConstrained: state.isConstrained
            )
        case .becameExpensive:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: true,
                isConstrained: state.isConstrained
            )
        case .becameConstrained:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: state.isExpensive,
                isConstrained: true
            )
        case .becameUnconstrained:
            state = .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: state.isExpensive,
                isConstrained: false
            )
        case .startMonitoring:
            state = .init(
                isMonitoring: true,
                connectivity: state.connectivity,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .stopMonitoring:
            state = .initial
        }
    }
}
