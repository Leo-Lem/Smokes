// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesModels", platforms: [.iOS(.v16), .macOS(.v10_15)])

// MARK: - (DEPENDENCIES)

let lib = (name: "SmokesLibrary", package: "lib")

package.dependencies = [
  .package(path: "../\(lib.package)")
]

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
  dependencies: [.product(name: lib.name, package: lib.package)],
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
