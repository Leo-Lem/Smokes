// swift-tools-version: 5.8

import PackageDescription

let package = Package(name: "SmokesReducers", platforms: [.iOS(.v16), .macOS(.v10_15)])

// MARK: - (DEPENDENCIES)

let tca = (name: "ComposableArchitecture", package: "swift-composable-architecture")
let models = (name: "SmokesModels", package: "models")
let deps = (name: "SmokesDependencies", package: "deps")
let lib = (name: "SmokesLibrary", package: "lib")

package.dependencies = [
  .package(url: "https://github.com/pointfreeco/\(tca.package)", from: "0.52.0"),
  .package(path: "../\(models.package)"),
  .package(path: "../\(deps.package)"),
  .package(path: "../\(lib.package)")
]

// MARK: - (TARGETS)

let target = Target.target(
  name: package.name,
  dependencies: [
    .product(name: tca.name, package: tca.package),
    .product(name: models.name, package: models.package),
    .product(name: deps.name, package: deps.package),
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
