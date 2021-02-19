import Foundation

public struct ReachabilityState: Equatable, Codable {
    /// The Middleware is active, so the NWPathMonitor is observing changes
    public let isMonitoring: Bool
    /// What's the latest known interface used to connect, or if it's disconnected
    public let connectivity: ConnectedInterface
    /// The path uses an interface that is considered expensive or not
    public let isExpensive: Bool
    /// The path uses an interface in Low (constrained) or High (unconstrained) Data Mode.
    public let isConstrained: Bool
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

public enum ConnectedInterface: String, Equatable, Codable {
    /// cellular (3G, LTE, 5G networks)
    case cellular
    /// Wi-fi, including Personal Hotpots
    case wifi
    /// Wired Ethernet
    case wired
    /// Disconnected
    case none
}
