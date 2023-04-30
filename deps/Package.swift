// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesDependencies", platforms: [.iOS(.v16), .macOS(.v10_15)])

// MARK: - (DEPENDENCIES)

let swiftDeps = (name: "Dependencies", package: "swift-dependencies")
let models = (name: "SmokesModels", package: "models")
let lib = (name: "SmokesLibrary", package: "lib")

package.dependencies = [
  .package(url: "https://github.com/pointfreeco/\(swiftDeps.package)", .upToNextMajor(from: "0.4.1")),
  .package(path: "../\(models.package)"),
  .package(path: "../\(lib.package)")
]

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
  dependencies: [
    .product(name: swiftDeps.name, package: swiftDeps.package),
    .product(name: models.name, package: models.package),
    .product(name: lib.name, package: lib.package)
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

package.products.append(.library(name: package.name, targets: [target.name]))
