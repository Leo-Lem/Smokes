// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesDependencies", platforms: [.iOS(.v16), .macOS(.v10_15)])

// MARK: - (DEPENDENCIES)

let swiftDeps = (name: "Dependencies", package: "swift-dependencies")

package.dependencies
  .append(.package(url: "https://github.com/pointfreeco/\(swiftDeps.package)", .upToNextMajor(from: "0.4.1")))

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
  dependencies: [.product(name: swiftDeps.name, package: swiftDeps.package)],
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
