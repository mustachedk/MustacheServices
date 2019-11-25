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
  targets: [
    .target(name: "MustacheServices")
  ]
)
