import Foundation

public struct ReachabilityState: Equatable, Codable {
    public let isMonitoring: Bool
    public let connectivity: ConnectedInterface
    public let isExpensive: Bool
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
    case cellular
    case wifi
    case wired
    case none
}
