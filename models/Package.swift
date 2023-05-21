// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesModels", platforms: [.iOS(.v16), .macOS(.v13)])

// MARK: - (DEPENDENCIES)

package.dependencies = [
  .package(url: "https://github.com/Leo-Lem/LeosSwift", from: "0.1.0"),
]

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
  dependencies: [.product(name: "LeosMisc", package: "LeosSwift")],
  path: "Sources"
)

let tests = Target.testTarget(
  name: "\(target.name)Tests",
  dependencies: [.target(name: target.name)],
  path: "Tests"
)

package.targets = [target, tests]

// MARK: - (PRODUCTS)

package.products.append(.library(name: package.name, targets: [target.name]))
