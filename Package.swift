import PackageDescription

let package = Package(
  name: "Kek",

  dependencies: [
    .Package(url: "https://github.com/ReSwift/ReSwift.git", majorVersion: 3)
  ]
)
