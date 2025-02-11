// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "Library", platforms: [.iOS(.v16), .macOS(.v13)], dependencies: [
  .package(path: "../extensions"),
  .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "1.0.0"),
  .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.1.0")
])

let deps = Target.Dependency.product(name: "Dependencies", package: "swift-dependencies")
let ext = Target.Dependency.product(name: "Extensions", package: "Extensions")
let lint = Target.PluginUsage.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")

let libs: [Target] = [
  .target(name: "Types", dependencies: [deps, ext], plugins: [lint]),
  .target(name: "Components", dependencies: [deps, ext, "Types"], plugins: [lint]),
  .target(name: "Calculate", dependencies: [deps, ext, "Types"], plugins: [lint]),
  .target(name: "Format", dependencies: [deps, ext, "Types"], plugins: [lint]),
  .target(name: "Code", dependencies: [deps], plugins: [lint])
]

package.targets = libs + [
  .testTarget(
    name: "LibraryTest",
    dependencies: libs.map { .byName(name: $0.name) },
    path: "Test",
    plugins: [lint]
  )
]

package.products.append(contentsOf: libs.map { .library(name: $0.name, targets: [$0.name]) })
