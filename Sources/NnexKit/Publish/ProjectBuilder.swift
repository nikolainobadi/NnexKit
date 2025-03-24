//
//  ProjectBuilder.swift
//  nnex
//
//  Created by Nikolai Nobadi on 3/19/25.
//

/// Responsible for building projects and creating binary files.
public struct ProjectBuilder {
    private let shell: Shell

    /// Initializes a new instance of ProjectBuilder.
    /// - Parameter shell: The shell used to execute build commands.
    public init(shell: Shell) {
        self.shell = shell
    }
}


// MARK: - Build
public extension ProjectBuilder {
    /// Builds a project with the specified configuration.
    /// - Parameters:
    ///   - name: The name of the project to build.
    ///   - path: The file path to the project directory.
    ///   - buildType: The type of build (e.g., universal, arm64, x86_64).
    ///   - extraBuildArgs: Additional arguments to pass to the build command.
    /// - Returns: A BinaryInfo object containing the binary path and SHA256 hash.
    /// - Throws: An error if the build process fails.
    func buildProject(name: String, path: String, buildType: BuildType, extraBuildArgs: [String]) throws -> BinaryInfo {
        let projectPath = path.hasSuffix("/") ? path : path + "/"

        for arch in buildType.archs {
            try build(for: arch, projectPath: projectPath, extraBuildArgs: extraBuildArgs)
        }

        let binaryPath: String
        if buildType == .universal {
            binaryPath = try buildUniversalBinary(projectName: name, projectPath: projectPath)
        } else {
            binaryPath = "\(projectPath).build/\(buildType.archs.first!.name)-apple-macosx/release/\(name)"
        }

        let sha256 = try getSha256(binaryPath: binaryPath)
        return .init(path: binaryPath, sha256: sha256)
    }
}

// MARK: - Private Methods
private extension ProjectBuilder {
    /// Builds the project for the specified architecture.
    /// - Parameters:
    ///   - arch: The target architecture for the build.
    ///   - projectPath: The file path to the project directory.
    ///   - extraBuildArgs: Additional arguments to pass to the build command.
    /// - Throws: An error if the build process fails.
    func build(for arch: ReleaseArchitecture, projectPath: String, extraBuildArgs: [String]) throws {
        print("🔨 Building for \(arch.name)...")
        let buildCommand = """
        swift build -c release --arch \(arch.name) -Xswiftc -Osize -Xswiftc -wmo -Xlinker -dead_strip_dylibs --package-path \(projectPath) \(extraBuildArgs.joined(separator: " "))
        """
        try shell.runAndPrint(buildCommand)
    }

    /// Retrieves the SHA256 hash of a binary file.
    /// - Parameter binaryPath: The file path to the binary.
    /// - Returns: The SHA256 hash as a string.
    /// - Throws: An error if the hash calculation fails.
    func getSha256(binaryPath: String) throws -> String {
        guard let sha256 = try? shell.run("shasum -a 256 \(binaryPath)").components(separatedBy: " ").first else {
            throw NnexError.missingSha256
        }
        return sha256
    }

    /// Builds a universal binary by combining architectures.
    /// - Parameters:
    ///   - projectName: The name of the project.
    ///   - projectPath: The file path to the project directory.
    /// - Returns: The file path of the created universal binary.
    /// - Throws: An error if the binary creation fails.
    func buildUniversalBinary(projectName: String, projectPath: String) throws -> String {
        let buildPath = "\(projectPath).build/universal"
        let universalBinaryPath = "\(buildPath)/\(projectName)"

        // TODO: - maybe move the print statements into a sort of 'progressHandler' to allow UI updates in CLI vs macOS
        print("📂 Creating universal binary folder at: \(buildPath)")
        try shell.runAndPrint("mkdir -p \(buildPath)")

        print("🔗 Combining architectures into universal binary...")
        let lipoCommand = """
        lipo -create -output \(universalBinaryPath) \
        \(projectPath).build/arm64-apple-macosx/release/\(projectName) \
        \(projectPath).build/x86_64-apple-macosx/release/\(projectName)
        """
        try shell.runAndPrint(lipoCommand)

        print("🗑 Stripping unneeded symbols...")
        try shell.runAndPrint("strip -u -r \(universalBinaryPath)")

        print("✅ Universal binary created at: \(universalBinaryPath)")
        return universalBinaryPath
    }
}


// MARK: - Extension Dependencies
fileprivate extension BuildType {
    /// Returns the list of architectures associated with the build type.
    var archs: [ReleaseArchitecture] {
        switch self {
        case .arm64:
            return [.arm]
        case .x86_64:
            return [.intel]
        case .universal:
            return [.arm, .intel]
        }
    }
}
