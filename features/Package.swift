// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "Features", platforms: [.iOS(.v16), .macOS(.v13)], dependencies: [
  .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
  .package(path: "../library"),
])

let libs: [Target] = [
  .target(name: "App", dependencies: [
    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    .product(name: "Components", package: "Library"),
    "Dashboard"
  ]),
  .target(name: "Dashboard", dependencies: [
    .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
    .product(name: "Components", package: "Library"),
    .product(name: "Types", package: "Library"),
    .product(name: "Format", package: "Library")
  ])
]

package.targets = libs.flatMap {[
    $0,
    .testTarget(
      name: "\($0.name)Tests",
      dependencies: [.target(name: $0.name)],
      path: "Test/\($0.name)"
    )
  ]}

package.products = libs.map { .library(name: $0.name, targets: [$0.name]) }
