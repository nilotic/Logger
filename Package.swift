// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Logger",
    platforms: [.macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7), .macCatalyst(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Logger",
            targets: ["Logger"]
        ),
        .executable(
            name: "LoggerClient",
            targets: ["LoggerClient"]
        ),
    ],
    dependencies: [
        // Depend on the Swift 5.9 release of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "LoggerMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
            ],
            linkerSettings: [.linkedFramework("OSLog")]
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "Logger", dependencies: ["LoggerMacros"], linkerSettings: [.linkedFramework("OSLog")]),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "LoggerClient", dependencies: ["Logger"]),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "LoggerTests",
            dependencies: [
                "LoggerMacros",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
