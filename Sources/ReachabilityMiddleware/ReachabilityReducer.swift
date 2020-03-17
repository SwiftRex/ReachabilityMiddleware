import Foundation
import SwiftRex

extension Reducer where ActionType == ReachabilityEvent, StateType == ReachabilityState {
    public static let reachability = Reducer { action, state in
        switch action {
        case .connectedToWifi:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: .wifi,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .connectedToWired:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: .wired,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .connectedToCellular:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: .cellular,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .gotOffline:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: .none,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .becameCheap:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: false,
                isConstrained: state.isConstrained
            )
        case .becameExpensive:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: true,
                isConstrained: state.isConstrained
            )
        case .becameConstrained:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: state.isExpensive,
                isConstrained: true
            )
        case .becameUnconstrained:
            return .init(
                isMonitoring: state.isMonitoring,
                connectivity: state.connectivity,
                isExpensive: state.isExpensive,
                isConstrained: false
            )
        case .startMonitoring:
            return .init(
                isMonitoring: true,
                connectivity: state.connectivity,
                isExpensive: state.isExpensive,
                isConstrained: state.isConstrained
            )
        case .stopMonitoring:
            return .initial
        }
    }
}
