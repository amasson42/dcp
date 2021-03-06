// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Dcpmaker",
    products: [
        .executable(name: "Dcpmaker", targets: ["Dcpmaker"]),
        .library(name: "SubjectFormat", targets: ["SubjectFormat"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "swift-argument-parser", url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Dcpmaker",
            dependencies: [
                "SubjectFormat",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .target(
            name: "SubjectFormat",
            dependencies: []
        ),
        .testTarget(
            name: "DcpmakerTests",
            dependencies: ["Dcpmaker"]),
        .testTarget(
            name: "SubjectFormatTests",
            dependencies: ["SubjectFormat"]),
    ]
)
