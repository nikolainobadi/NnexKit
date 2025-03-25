//
//  ExecutableDetectorTests.swift
//  NnexKit
//
//  Created by Nikolai Nobadi on 3/25/25.
//

import Testing
@testable import NnexKit

struct ExecutableDetectorTests {
    @Test("Returns an array of executable names when multiple executables are present")
    func parsesMultipleExecutables() {
        let executables = ExecutableDetector.getExecutables(packageManifestContent: TestData.multipleExecutables)
        assert(executables == ["FirstExecutable", "SecondExecutable"])
    }

    @Test("Returns an empty array when no executables are present")
    func parsesNoExecutables() {
        let executables = ExecutableDetector.getExecutables(packageManifestContent: TestData.noExecutables)
        assert(executables.isEmpty)
    }

    @Test("Returns array with a single executable when only one executable is present")
    func parsesSingleExecutable() {
        let executables = ExecutableDetector.getExecutables(packageManifestContent: TestData.singleExecutable)
        assert(executables == ["SingleExecutable"])
    }

    @Test("Ignores malformed executable entries")
    func ignoresMalformedEntries() {
        let executables = ExecutableDetector.getExecutables(packageManifestContent: TestData.malformedExecutable)
        assert(executables == ["ValidExecutable"])
    }
}



// MARK: - Test Data
private extension ExecutableDetectorTests {
    enum TestData {
        static let multipleExecutables = """
        // swift-tools-version:5.9
        import PackageDescription

        let package = Package(
            name: "MyTestPackage",
            products: [
                .library(
                    name: "MyLibrary",
                    targets: ["MyLibrary"]
                ),
                .executable(
                    name: "FirstExecutable",
                    targets: ["FirstTarget"]
                ),
                .executable(
                    name: "SecondExecutable",
                    targets: ["SecondTarget"]
                ),
            ],
            targets: [
                .target(
                    name: "MyLibrary",
                    dependencies: []
                ),
                .executableTarget(
                    name: "FirstTarget",
                    dependencies: []
                ),
                .executableTarget(
                    name: "SecondTarget",
                    dependencies: []
                ),
            ]
        )
        """

        static let noExecutables = """
        // swift-tools-version:5.9
        import PackageDescription

        let package = Package(
            name: "MyTestPackage",
            products: [
                .library(
                    name: "MyLibrary",
                    targets: ["MyLibrary"]
                )
            ],
            targets: [
                .target(
                    name: "MyLibrary",
                    dependencies: []
                )
            ]
        )
        """

        static let singleExecutable = """
        // swift-tools-version:5.9
        import PackageDescription

        let package = Package(
            name: "MyTestPackage",
            products: [
                .executable(
                    name: "SingleExecutable",
                    targets: ["SingleTarget"]
                )
            ],
            targets: [
                .executableTarget(
                    name: "SingleTarget",
                    dependencies: []
                )
            ]
        )
        """

        static let malformedExecutable = """
        // swift-tools-version:5.9
        import PackageDescription

        let package = Package(
            name: "MyTestPackage",
            products: [
                .executable(
                    name: "ValidExecutable",
                    targets: ["ValidTarget"]
                ),
                .executable(name: , targets: ["MalformedTarget"])
            ],
            targets: [
                .executableTarget(
                    name: "ValidTarget",
                    dependencies: []
                )
            ]
        )
        """
    }
}
