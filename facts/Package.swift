// swift-tools-version: 5.8

import PackageDescription

let package = Package(
  name: "FactsAPI",
  platforms: [.macOS(.v12)]
)

// MARK: - (DEPENDENCIES)

let vapor = "vapor"

package.dependencies.append(.package(url: "https://github.com/vapor/\(vapor)", from: "4.76.0"))

// MARK: - (TARGETS)

let api: Target = .executableTarget(
  name: "FactsAPI",
  dependencies: [
    .product(name: "Vapor", package: vapor)
  ],
  path: "Sources"
)

let apiTests: Target = .testTarget(
  name: "\(api.name)Tests",
  dependencies: [
    .target(name: api.name),
      .product(name: "XCTVapor", package: vapor)
  ],
  path: "Tests"
)

package.targets = [api, apiTests]

