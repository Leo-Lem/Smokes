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
  .target(name: "Bundle", dependencies: [deps, ext], plugins: [lint]),
]

package.targets.append(contentsOf: libs.flatMap {[
    $0,
    .testTarget(
      name: "\($0.name)Tests",
      dependencies: [.target(name: $0.name)],
      path: "Test/\($0.name)"
    )
  ]}
)

package.products.append(contentsOf: libs.map { .library(name: $0.name, targets: [$0.name]) })
