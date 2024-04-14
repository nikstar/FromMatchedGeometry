// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FromMatchedGeometry",
    platforms: [
        .macOS(.v11),
        .iOS(.v13)
    ],
    products: [
        .library(name: "FromMatchedGeometry", targets: ["FromMatchedGeometry"]),
    ],
    targets: [
        .target(name: "FromMatchedGeometry"),
    ]
)
