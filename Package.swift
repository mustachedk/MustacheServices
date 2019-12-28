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
  ],
  targets: [
    .target(name: "MustacheServices",dependencies: ["Resolver"])
  ]
)
