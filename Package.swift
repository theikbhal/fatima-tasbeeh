// swift-tools-version:5.9
import PackageDescription
let package = Package(
    name: "Tasbih",
    platforms: [.macOS(.v13)],
    targets: [.executableTarget(name: "Tasbih", path: "Sources/Tasbih")]
)
