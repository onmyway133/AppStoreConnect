// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStoreConnect",
    platforms: [.iOS(.v13), .macCatalyst(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(name: "AppStoreConnect", targets: ["AppStoreConnect"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kean/Get", from: "0.3.1"), 
        .package(url: "https://github.com/kean/NaiveDate", from: "1.0.0"), 
        .package(url: "https://github.com/kean/URLQueryEncoder", branch: "0.2.0"),
        .package(url: "https://github.com/vapor/jwt-kit", from: "4.0.0")
    ],
    targets: [
        .target(name: "AppStoreConnect", dependencies: [
            .product(name: "Get", package: "Get"), 
            .product(name: "NaiveDate", package: "NaiveDate"), 
            .product(name: "URLQueryEncoder", package: "URLQueryEncoder"),
            .product(name: "JWTKit", package: "jwt-kit")
        ], path: "Sources")
    ]
)
