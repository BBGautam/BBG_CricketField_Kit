// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:5.7
import PackageDescription

// swift-tools-version: 5.9

let package = Package(
    name: "BBG_CricketField_Kit",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "BBG_CricketField_Kit",
            targets: ["BBG_CricketField_Kit"]
        ),
    ],
    targets: [
        .target(
            name: "BBG_CricketField_Kit",
            path: "Sources/BBG_CricketField_Kit"
        ),
        .testTarget(
            name: "BBG_CricketField_KitTests",
            dependencies: ["BBG_CricketField_Kit"]
        ),
    ]
)

