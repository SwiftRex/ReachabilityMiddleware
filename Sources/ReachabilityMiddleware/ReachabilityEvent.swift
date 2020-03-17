import Foundation

public enum ReachabilityEvent: Equatable {
    case startMonitoring
    case stopMonitoring
    case connectedToWifi
    case connectedToWired
    case connectedToCellular
    case gotOffline
    case becameExpensive
    case becameCheap
    case becameConstrained
    case becameUnconstrained
}
