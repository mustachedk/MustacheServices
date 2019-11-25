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
    .package(url: "https://github.com/ralcr/SwiftKeychainWrapper.git", .upToNextMajor(from: "3.0.0")),
 ],
  targets: [
    .target(name: "MustacheServices", dependencies: ["SwiftKeychainWrapper"])
  ]
)
