// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "Features", platforms: [.iOS(.v16), .macOS(.v13)], dependencies: [
  .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.0.0"),
  .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0"),
  .package(path: "../library"),
  .package(path: "../extensions"),
  .package(path: "../resource/generated")
])

let tca = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
let ext = Target.Dependency.product(name: "Extensions", package: "Extensions")
let comps = Target.Dependency.product(name: "Components", package: "Library")
let types = Target.Dependency.product(name: "Types", package: "Library")
let format = Target.Dependency.product(name: "Format", package: "Library")
let calc = Target.Dependency.product(name: "Calculate", package: "Library")
let code = Target.Dependency.product(name: "Code", package: "Library")
let bundle = Target.Dependency.product(name: "Bundle", package: "Library")
let gen = Target.Dependency.product(name: "Generated", package: "Generated")
let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "App", dependencies: [
    tca, comps, gen, "Dashboard", "History", "Statistic", "Fact", "Info", "Transfer"
  ], plugins: [lint]),
  .target(name: "Dashboard", dependencies: [tca, gen, comps, types, bundle, format, calc], plugins: [lint]),
  .target(name: "History", dependencies: [tca, gen, comps, types, bundle, format, calc], plugins: [lint]),
  .target(name: "Statistic", dependencies: [tca, gen, comps, types, bundle, format, calc], plugins: [lint]),
  .target(name: "Fact", dependencies: [tca, gen, ext, bundle], plugins: [lint]),
  .target(name: "Info", dependencies: [tca, gen, ext, bundle], plugins: [lint]),
  .target(name: "Transfer", dependencies: [tca, gen, ext, comps, types, bundle,code], plugins: [lint]),
]

package.targets = libs + [
  .testTarget(
    name: "FeaturesTest",
    dependencies: libs.map { .byName(name: $0.name) },
    path: "Test",
    plugins: [lint]
  )
]

package.products = libs.map { .library(name: $0.name, targets: [$0.name]) }
