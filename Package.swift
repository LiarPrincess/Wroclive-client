import PackageDescription

let package = Package(
  name: "Kek",

  dependencies: [
    .Package(url: "https://github.com/ReSwift/ReactiveReSwift.git", majorVersion: 3)
  ]
)
