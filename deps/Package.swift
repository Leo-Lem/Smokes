// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesDependencies", platforms: [.iOS(.v16), .macOS(.v13)])

// MARK: - (DEPENDENCIES)

package.dependencies = [
  .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.5.0"),
  .package(url: "https://github.com/Leo-Lem/LeosSwift", from: "0.1.0"),
  .package(path: "../models"),
]

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
  dependencies: [
    .product(name: "Dependencies", package: "swift-dependencies"),
    .product(name: "LeosMisc", package: "LeosSwift"),
    .product(name: "SmokesModels", package: "models")
  ],
  path: "Sources"
)

let tests = Target.testTarget(
  name: "\(target.name)Tests",
  dependencies: [.target(name: target.name)],
  path: "Tests"
)

package.targets = [target, tests]

// MARK: - (PRODUCTS)

package.products = [.library(name: package.name, targets: [target.name])]
