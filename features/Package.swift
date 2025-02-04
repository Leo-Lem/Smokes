// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "Features", platforms: [.iOS(.v16), .macOS(.v13)], dependencies: [
  .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
  .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
  .package(path: "../library"),
  .package(path: "../extensions"),
])

let tca = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let ext = Target.Dependency.product(name: "Extensions", package: "Extensions")
let comps = Target.Dependency.product(name: "Components", package: "Library")
let types = Target.Dependency.product(name: "Types", package: "Library")
let format = Target.Dependency.product(name: "Format", package: "Library")
let calc = Target.Dependency.product(name: "Calculate", package: "Library")
let bundle = Target.Dependency.product(name: "Bundle", package: "Library")
let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "App", dependencies: [tca, comps, "Dashboard", "Fact", "Info"], plugins: [lint]),
  .target(name: "Dashboard", dependencies: [tca, comps, types, format, calc], plugins: [lint]),
  .target(name: "Fact", dependencies: [tca, ext, bundle], plugins: [lint]),
  .target(name: "Info", dependencies: [ext, bundle], plugins: [lint]),
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
