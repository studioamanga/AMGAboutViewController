// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "AMGAboutViewController",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13), .macOS(.v10_15)
    ],
    products: [
        .library(name: "AMGAboutViewController", targets: ["AMGAboutViewController"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/studioamanga/AMGAppButton.git",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/vtourraine/AcknowList.git",
            from: "2.0.0"
        ),
        .package(
            url: "https://github.com/vtourraine/TrackupVersionHistory.git",
            from: "0.1.0"
        )
    ],
    targets: [
        .target(
            name: "AMGAboutViewController",
            dependencies: ["AMGAppButton", "AcknowList", "TrackupVersionHistory"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
