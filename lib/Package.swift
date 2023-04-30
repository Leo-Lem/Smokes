// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesLibrary", platforms: [.iOS(.v15), .macOS(.v10_15)])

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
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
