// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "MustacheServices",
  platforms: [
    .iOS(.v11)
  ],
  products: [
    .library(name: "MustacheServices", targets: ["MustacheServices"]),
  ],
  dependencies: [
     .package(url: "https://github.com/hmlongco/Resolver.git", .upToNextMajor(from: "1.1.1")),
     .package(url: "https://github.com/mustachedk/MustacheFoundation.git", .upToNextMajor(from: "1.1.0"))
  ],
  targets: [
    .target(name: "MustacheServices",dependencies: ["Resolver", "MustacheFoundation"])
  ]
)
