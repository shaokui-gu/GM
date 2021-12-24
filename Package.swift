
// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GM",
    platforms: [
        .iOS(.v11),
    ],
    products: [
        .library(name: "GM", targets: ["GM"])
    ],
    dependencies: [
        .package(url: "https://github.com/shaokui-gu/OpenUDID.git", from: "1.0.1"),
    ],
    targets: [
        .target(
            name: "GM",
            dependencies: [
                "OpenUDID",
            ],
            path: "Sources"
        ),
        .testTarget(
            name: "GMTests",
            dependencies: ["GM"]),
    ]
)
