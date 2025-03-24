//
//  SwiftDataFormula.swift
//  nnex
//
//  Created by Nikolai Nobadi on 3/22/25.
//

import SwiftData

/// Represents a Homebrew formula with metadata and build configuration.
@Model
public final class SwiftDataFormula {
    /// The name of the formula.
    public var name: String

    /// A description of the formula.
    public var details: String

    /// The homepage URL of the formula.
    public var homepage: String

    /// The license under which the formula is distributed.
    public var license: String

    /// The local path of the project associated with the formula.
    public var localProjectPath: String

    /// The upload type for the formula (binary or tarball).
    public var uploadType: FormulaUploadType

    /// Additional build arguments for the formula.
    public var extraBuildArgs: [String]

    /// The tap associated with the formula.
    public var tap: SwiftDataTap?

    /// Initializes a new instance of SwiftDataFormula.
    /// - Parameters:
    ///   - name: The name of the formula.
    ///   - details: A description of the formula.
    ///   - homepage: The homepage URL of the formula.
    ///   - license: The license of the formula.
    ///   - localProjectPath: The local path of the associated project.
    ///   - uploadType: The upload type (binary or tarball).
    ///   - extraBuildArgs: Additional build arguments.
    public init(name: String, details: String, homepage: String, license: String, localProjectPath: String, uploadType: FormulaUploadType, extraBuildArgs: [String]) {
        self.name = name
        self.details = details
        self.homepage = homepage
        self.license = license
        self.localProjectPath = localProjectPath
        self.uploadType = uploadType
        self.extraBuildArgs = extraBuildArgs
    }
}


// MARK: - Dependencies
/// Represents the upload type for a formula.
public enum FormulaUploadType: String, Codable {
    /// Upload as a binary file.
    case binary

    /// Upload as a tarball file.
    case tarball
}
