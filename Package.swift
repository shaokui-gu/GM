
// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "GM",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "GM", targets: ["GM"])
    ],
    dependencies: [
        .package(url: "https://github.com/shaokui-gu/OpenUDID.git", from: "1.0.1"),
        .package(url: "https://github.com/shaokui-gu/KeychainItemWrapper.git", from: "0.0.2"),
        .package(url: "https://github.com/jdg/MBProgressHUD.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "GM",
            dependencies: [
                "OpenUDID",
                "KeychainItemWrapper",
                "MBProgressHUD"
            ],
            path: "Sources"
        )
    ]
)
