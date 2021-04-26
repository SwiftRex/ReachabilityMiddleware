import Foundation
import Network

public protocol NWPathProtocol {
    func usesInterfaceType(_ type: NWInterface.InterfaceType) -> Bool
    var isExpensive: Bool { get }
    var isConstrained: Bool { get }
}
