//
//  BuildConfig.swift
//  NnexKit
//
//  Created by Nikolai Nobadi on 3/25/25.
//

/// Represents the configuration for building a project.
public struct BuildConfig {
    /// Specifies the command to use for running tests.
    public enum TestCommand {
        /// Uses the default `swift test` command.
        case defaultCommand
        /// Uses a custom test command provided as a string.
        case custom(String)
    }

    /// The name of the project to build.
    public let projectName: String
    /// The file path to the project directory.
    public let projectPath: String
    /// The type of build to perform (e.g., universal, arm64, x86_64).
    public let buildType: BuildType
    /// Additional arguments to pass to the build command.
    public let extraBuildArgs: [String]
    /// Indicates whether the project should be cleaned before building.
    public let shouldClean: Bool
    /// An optional command to run tests after building.
    public let testCommand: TestCommand?

    /// Initializes a new `BuildConfig` with the specified settings.
    ///
    /// - Parameters:
    ///   - projectName: The name of the project to build.
    ///   - projectPath: The file path to the project directory.
    ///   - buildType: The type of build to perform (e.g., universal, arm64, x86_64).
    ///   - extraBuildArgs: Additional arguments to pass to the build command.
    ///   - shouldClean: Indicates whether the project should be cleaned before building. Defaults to `true`.
    ///   - testCommand: An optional command to run tests after building. Defaults to `nil`, meaning no tests will be run.
    public init(
        projectName: String,
        projectPath: String,
        buildType: BuildType,
        extraBuildArgs: [String] = [],
        shouldClean: Bool = true,
        testCommand: TestCommand? = nil
    ) {
        self.projectName = projectName
        self.projectPath = projectPath.hasSuffix("/") ? projectPath : projectPath + "/"
        self.buildType = buildType
        self.extraBuildArgs = extraBuildArgs
        self.shouldClean = shouldClean
        self.testCommand = testCommand
    }
}

