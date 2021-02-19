# ReachabilityMiddleware

## Actions

Control the Middleware: Dispatch these actions to the stop in order to start or stop the middleware:

```swift
ReachabilityEvent.startMonitoring      // Start the NWPathMonitor and the Middleware actions
ReachabilityEvent.stopMonitoring       // Stop the NWPathMonitor and cease the actions
```

Middleware events: these actions will be triggered by the middleware whenever NWPath is notified and differs from current state:

- Related to the network interface

```swift
ReachabilityEvent.connectedToWifi      // The connection is now routed through the wi-fi
ReachabilityEvent.connectedToWired     // The connection is now routed through the wired ethernet
ReachabilityEvent.connectedToCellular  // The connection is now routed through the cellular network
ReachabilityEvent.gotOffline           // The connection was lost and device seems to be offline
```

- Related to the network cost

```swift
ReachabilityEvent.becameExpensive      // The path uses an interface that is considered expensive, such as Cellular or a Personal Hotspot.
ReachabilityEvent.becameCheap          // The path uses an interface that is considered cheap, such as home Wi-fi or Ethernet.
ReachabilityEvent.becameConstrained    // The path uses an interface in Low Data Mode.
ReachabilityEvent.becameUnconstrained  // The path uses an interface in High Data Mode.
```

## State

```swift
public struct ReachabilityState: Equatable, Codable {
    public let isMonitoring: Bool                // The Middleware is active, so the NWPathMonitor is observing changes
    public let connectivity: ConnectedInterface  // What's the latest known interface used to connect, or if it's disconnected
    public let isExpensive: Bool                 // The path uses an interface that is considered expensive or not
    public let isConstrained: Bool               // The path uses an interface in Low (constrained) or High (unconstrained) Data Mode.
}

public enum ConnectedInterface: String, Equatable, Codable {
    case cellular   // cellular (3G, LTE, 5G networks)
    case wifi       // Wi-fi, including Personal Hotpots
    case wired      // Wired Ethernet
    case none       // Disconnected
}
```

## Combine Publisher

`NWPathMonitorPublisher`:
Publisher for NWPathMonitor, emitting NWPath for every pathUpdateHandler event. It never fails.
Important: it doesn't respect the demand, it's used only in this middleware that asks for unlimited demand, any use in other contexts should consider that the back-pressure will be ignored, with the exception of the first demand different than .none which will kickstart the side-effect, but regardless of how much the demand is sent by the subscriber, the publisher will make it unlimited.

```swift
let cancellable = NWPathMonitor().publisher.sink { path in 
    let isEthernet = path.usesInterfaceType(.wiredEthernet)
    // ...
}
```

## Effect Middleware

This effect middleware has dependency on `ReachabilityMiddlewareDependencies`, which simply wraps a constructor for a `NWPathMonitorPublisher`.

Some examples of how this dependency should be created:

```swift
let dep1 = ReachabilityMiddlewareDependencies.production()
let dep2 = ReachabilityMiddlewareDependencies.production(requiredInterfaceType: .wifi)
let dep3 = ReachabilityMiddlewareDependencies.production(prohibitedInterfaceTypes: [.wifi])
let mock = PassthroughSubject<NWPath, Never>()
let dep4 = ReachabilityMiddlewareDependencies.forTests(subject: mock)
let dep5 = ReachabilityMiddlewareDependencies(pathMonitor: { publisherOfNWPath.eraseToAnyPublisher() })
```

Regardless of how you created it, you can inject it into the MiddlewareReader. Internally, the middleware will use `dep1.pathMonitor().sink`.

```swift
let middleware = EffectMiddleware<ReachabilityEvent, ReachabilityEvent, ReachabilityState, ReachabilityMiddlewareDependencies>
    .reachability
    .inject(dep1)

let store = ... // lift and use the middleware
store.dispatch(.reachabilitySubState(.startMonitoring))
```

## Reducer

The reducer will update your AppState according to the actions received by the middleware.

```swift
let reducer = Reducer<ReachabilityEvent, ReachabilityState>.reachability

let store = ... // lift and use the reducer
store.dispatch(.reachabilitySubState(.startMonitoring))
```