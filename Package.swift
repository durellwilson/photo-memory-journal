// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PhotoMemoryJournal",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "PhotoMemoryJournal", targets: ["PhotoMemoryJournal"]),
    ],
    targets: [
        .target(name: "PhotoMemoryJournal"),
    ]
)
