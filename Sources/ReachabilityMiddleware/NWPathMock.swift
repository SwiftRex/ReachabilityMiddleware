import Network

#if DEBUG
public class NWPathMock: NWPathProtocol {
    public init(
        isExpensive: Bool = false,
        isConstrained: Bool = false,
        usesInterfaceTypeClosure: @escaping (NWInterface.InterfaceType) -> Bool = { _ in true },
        usesInterfaceTypeCalls: Int = 0,
        usesInterfaceTypeCallsParams: [NWInterface.InterfaceType] = []
    ) {
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.usesInterfaceTypeClosure = usesInterfaceTypeClosure
        self.usesInterfaceTypeCalls = usesInterfaceTypeCalls
        self.usesInterfaceTypeCallsParams = usesInterfaceTypeCallsParams
    }

    public var isExpensive: Bool
    public var isConstrained: Bool
    public var usesInterfaceTypeClosure: (NWInterface.InterfaceType) -> Bool = { _ in true }
    public var usesInterfaceTypeCalls: Int = 0
    public var usesInterfaceTypeCallsParams: [NWInterface.InterfaceType] = []

    public func usesInterfaceType(_ type: NWInterface.InterfaceType) -> Bool {
        usesInterfaceTypeCalls += 1
        usesInterfaceTypeCallsParams += [type]
        return usesInterfaceTypeClosure(type)
    }
}
#endif

