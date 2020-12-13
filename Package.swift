// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "DisplaySwitcher",
    platforms: [
        .iOS(.v8),
    ],
    products: [
        .library(
            name: "DisplaySwitcher",
            targets: ["DisplaySwitcher"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DisplaySwitcher",
            dependencies: [],
            path: "Pod",
            exclude: [
                "Info.plist",
            ],
            sources: [
                "Classes",
            ]
        ),
    ]
)
