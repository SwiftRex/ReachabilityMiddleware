import Foundation

public enum ReachabilityEvent: Hashable {
    /// Start the NWPathMonitor and the Middleware actions
    case startMonitoring
    /// Stop the NWPathMonitor and cease the actions
    case stopMonitoring
    /// The connection is now routed through the wi-fi
    case connectedToWifi
    /// The connection is now routed through the wired ethernet
    case connectedToWired
    /// The connection is now routed through the cellular network
    case connectedToCellular
    /// The connection was lost and device seems to be offline
    case gotOffline
    /// The path uses an interface that is considered expensive, such as Cellular or a Personal Hotspot.
    case becameExpensive
    /// The path uses an interface that is considered cheap, such as home Wi-fi or Ethernet.
    case becameCheap
    /// The path uses an interface in Low Data Mode.
    case becameConstrained
    /// The path uses an interface in High Data Mode.
    case becameUnconstrained
}
