// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "AshtrayPackage",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "AshtrayPackage",
                 targets: [
                    "AshtrayLogic",
                    "AshtrayUIElements"
                 ])
    ],
    dependencies: [
        .package(path: "../MyPackage")
    ],
    targets: [
        .target(name: "AshtrayLogic",
                dependencies: [
                    "MyPackage"
                ]),
        .target(name: "AshtrayUIElements",
                dependencies: [
                    "AshtrayLogic",
                    "MyPackage"
                ])
    ]
)
