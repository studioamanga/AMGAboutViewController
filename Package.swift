// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AMGAboutViewController",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "AMGAboutViewController", targets: ["AMGAboutViewController"])
    ],
    dependencies: [
        .package(path: "../AMGAppButton"),
        .package(
            url: "https://github.com/vtourraine/AcknowList.git",
            from: "2.0.0"
        )
    ],
    targets: [
        .target(
            name: "AMGAboutViewController",
            dependencies: ["AMGAppButton", "AcknowList"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
