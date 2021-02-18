// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReachabilityMiddleware",
    platforms: [
        .iOS(.v13), .macOS(.v10_15), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(name: "ReachabilityMiddleware", targets: ["ReachabilityMiddleware"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftRex/SwiftRex.git", from: "0.8.2")
    ],
    targets: [
        .target(name: "ReachabilityMiddleware", dependencies: ["CombineRex"]),
        .testTarget(name: "ReachabilityMiddlewareTests", dependencies: ["ReachabilityMiddleware"])
    ]
)
