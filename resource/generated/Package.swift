// swift-tools-version: 6.0

import PackageDescription

let package = Package(name: "Generated", platforms: [.iOS(.v16), .macOS(.v13)], dependencies: [
  .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0"),
])

package.targets.append(
  .target(name: "Generated", path: ".", plugins: [.plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin")])
)

package.products.append(
  .library(name: "Generated", targets: ["Generated"])
)
