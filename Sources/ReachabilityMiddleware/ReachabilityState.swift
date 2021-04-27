import Foundation

public struct ReachabilityState: Codable, Hashable {
    /// The Middleware is active, so the NWPathMonitor is observing changes
    public var isMonitoring: Bool
    /// What's the latest known interface used to connect, or if it's disconnected
    public var connectivity: ConnectedInterface
    /// The path uses an interface that is considered expensive or not
    public var isExpensive: Bool
    /// The path uses an interface in Low (constrained) or High (unconstrained) Data Mode.
    public var isConstrained: Bool
}

extension ReachabilityState {
    public static var initial: ReachabilityState {
        .init(
            isMonitoring: false,
            connectivity: .none,
            isExpensive: true,
            isConstrained: true
        )
    }
}

public enum ConnectedInterface: String, Codable, Hashable {
    /// cellular (3G, LTE, 5G networks)
    case cellular
    /// Wi-fi, including Personal Hotpots
    case wifi
    /// Wired Ethernet
    case wired
    /// Disconnected
    case none
}
