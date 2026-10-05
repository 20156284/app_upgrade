// swift-tools-version: 5.9

import PackageDescription

let package = Package(
  name: "app_upgrade",
  platforms: [
    .iOS("13.0")
  ],
  products: [
    .library(name: "app-upgrade", targets: ["app_upgrade"])
  ],
  dependencies: [
    .package(name: "FlutterFramework", path: "../FlutterFramework")
  ],
  targets: [
    .target(
      name: "app_upgrade",
      dependencies: [
        .product(name: "FlutterFramework", package: "FlutterFramework")
      ]
    )
  ]
)
