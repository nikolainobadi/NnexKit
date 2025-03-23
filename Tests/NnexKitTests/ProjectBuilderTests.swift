//
//  ProjectBuilderTests.swift
//  nnex
//
//  Created by Nikolai Nobadi on 3/20/25.
//

import Testing
import NnexSharedTestHelpers
@testable import NnexKit

struct ProjectBuilderTests {
    private let sha256 = "abc123def456"
    private let projectName = "TestProject"
    private let projectPath = "/path/to/project"
}


// MARK: - Unit Tests
extension ProjectBuilderTests {
    @Test("Successfully builds a universal binary")
    func buildUniversalBinary() throws {
        let sut = makeSUT(runResults: [sha256]).sut
        let result = try getBuildResult(sut: sut)
        
        #expect(result.path.contains(projectPath))
        #expect(result.path.contains(projectName))
        #expect(result.sha256 == sha256, "Expected SHA-256 \(sha256), but got \(result.sha256)")
    }
    
    @Test("Throws error if build for architecture fails")
    func buildArchitectureFails() throws {
        let (sut, _) = makeSUT(throwShellError: true)
        
        #expect(throws: (any Error).self) {
            try getBuildResult(sut: sut)
        }
    }
    
    @Test("Throws error if universal binary creation fails")
    func buildUniversalBinaryFails() throws {
        let (sut, _) = makeSUT(runResults: ["some/path"], throwShellError: true)
        
        #expect(throws: (any Error).self) {
            try getBuildResult(sut: sut)
        }
    }
    
    @Test("Throws error if SHA-256 calculation fails")
    func sha256CalculationFails() throws {
        let (sut, _) = makeSUT(runResults: ["some/path"], throwShellError: true)
        
        #expect(throws: (any Error).self) {
            try getBuildResult(sut: sut)
        }
    }
    
    @Test("Successfully builds an arm64 binary")
    func buildArm64Binary() throws {
        let sut = makeSUT(runResults: [sha256]).sut
        let result = try getBuildResult(sut: sut, buildType: .arm64)
        
        #expect(result.path.contains(projectPath))
        #expect(result.path.contains("arm64-apple-macosx"))
        #expect(result.path.contains(projectName))
        #expect(result.sha256 == sha256, "Expected SHA-256 \(sha256), but got \(result.sha256)")
    }
    
    @Test("Successfully builds an x86_64 binary")
    func buildX86_64Binary() throws {
        let sut = makeSUT(runResults: [sha256]).sut
        let result = try getBuildResult(sut: sut, buildType: .x86_64)
        
        #expect(result.path.contains(projectPath))
        #expect(result.path.contains("x86_64-apple-macosx"))
        #expect(result.path.contains(projectName))
        #expect(result.sha256 == sha256, "Expected SHA-256 \(sha256), but got \(result.sha256)")
    }
    
    @Test("Successfully passes extra build arguments")
    func buildWithExtraArgs() throws {
        let extraArgs = ["-DAPP_GROUP_ID=\\\"group.com.yourcompany.nnexkit\\\""]
        let (sut, shell) = makeSUT(runResults: [sha256])
        
        let result = try getBuildResult(sut: sut, extraBuildArgs: extraArgs)
        
        // Verify the build command contains the extra arguments
        let expectedCommandPart = extraArgs.joined(separator: " ")
        #expect(shell.printedCommands.contains { $0.contains(expectedCommandPart) })
        
        #expect(result.path.contains(projectPath))
        #expect(result.path.contains(projectName))
        #expect(result.sha256 == sha256, "Expected SHA-256 \(sha256), but got \(result.sha256)")
    }

}

// MARK: - SUT
private extension ProjectBuilderTests {
    func makeSUT(runResults: [String] = [], throwShellError: Bool = false) -> (sut: ProjectBuilder, shell: MockShell) {
        let shell = MockShell(runResults: runResults, shouldThrowError: throwShellError)
        let sut = ProjectBuilder(shell: shell)
        return (sut, shell)
    }
}


// MARK: - Helper Methods
private extension ProjectBuilderTests {
    func getBuildResult(sut: ProjectBuilder, buildType: BuildType = .universal, extraBuildArgs: [String] = []) throws -> BinaryInfo {
        try sut.buildProject(name: projectName, path: projectPath, buildType: buildType, extraBuildArgs: extraBuildArgs)
    }
}
