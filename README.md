# NnexKit

![Build Status](https://github.com/nikolainobadi/NnexKit/actions/workflows/ci.yml/badge.svg)
![Swift Version](https://badgen.net/badge/swift/6.0%2B/purple)
![Platform](https://img.shields.io/badge/platform-macOS%2014-blue)
![License](https://img.shields.io/badge/license-MIT-lightgray)


NnexKit is a Swift package designed to streamline the management and distribution of Homebrew Taps and Formulas, as well as facilitate project building and version handling for macOS applications. It provides robust Git integration, version management utilities, formula publishing tools, and more.

## Features
- Create and manage Homebrew Taps and Formulas.
- Build binaries for different architectures.
- Automate Git operations such as committing and pushing.
- Manage versioning, including version incrementation.
- Detect licenses in project directories.

## Installation

To install NnexKit, add the package to your `Package.swift` file as follows:

```swift
dependencies: [
    .package(url: "https://github.com/nikolainobadi/NnexKit", from: "0.7.0")
]
```

## Usage

### Importing the Package
To start using NnexKit, import it at the top of your Swift file:

```swift
import NnexKit
```

### Creating and Managing Taps
NnexKit makes it simple to create and manage Homebrew Taps:

```swift
let context = try NnexContext(appGroupId: "group.com.example.app")
let tap = SwiftDataTap(name: "my-tap", localPath: "/path/to/tap", remotePath: "https://github.com/user/my-tap")
try context.saveNewTap(tap)
```

### Publishing a Formula
Publishing a new formula to your Tap is straightforward:

```swift
let formulaContent = FormulaContentGenerator.makeFormulaFileContent(
    name: "my-app",
    details: "A cool app built with Swift",
    homepage: "https://example.com",
    license: "MIT",
    assetURL: "https://github.com/user/my-app/releases/download/v1.0.0/my-app.zip",
    sha256: "abc123..."
)

let publisher = FormulaPublisher(gitHandler: DefaultGitHandler(shell: DefaultShell()))
try publisher.publishFormula(formulaContent, formulaName: "my-app", commitMessage: "Add my-app formula", tapFolderPath: "/path/to/tap")
```

### Building Projects
Use NnexKit to build binaries with specific architectures:

```swift
let builder = ProjectBuilder(shell: DefaultShell())
let binaryInfo = try builder.buildProject(
    name: "my-app",
    path: "/path/to/project",
    buildType: .universal,
    extraBuildArgs: ["--enable-test-discovery"]
)
print("Binary created at: \(binaryInfo.path)")
```

### Handling Versions
Increment or validate version numbers with the `VersionHandler`:

```swift
let isValid = VersionHandler.isValidVersionNumber("1.0.0")
print("Version is valid: \(isValid)")

let newVersion = try VersionHandler.incrementVersion(for: .minor, path: "/path/to/project", previousVersion: "1.0.0")
print("New version: \(newVersion)")
```

### License Detection
Easily detect the license of a project directory:

```swift
import Files

let projectFolder = try Folder(path: "/path/to/project")
let licenseType = LicenseDetector.detectLicense(in: projectFolder)
print("Detected license: \(licenseType)")
```

## Documentation
All public functions and types are documented inline. For a deeper understanding of the package, browse the code or read the inline documentation.

## Contributing
Any feedback or ideas to enhance NnexKit would be well received. Please feel free to [open an issue](https://github.com/nikolainobadi/NnexKit/issues/new) if you'd like to help improve this Swift package.

## License
NnexKit is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements
NnexKit leverages several Swift libraries, including:

### Third-Party Libraries
- [Files](https://github.com/JohnSundell/Files) for file management
- [SwiftShell](https://github.com/kareman/SwiftShell) for command-line interactions    

### My Packages
- [GitShellKit](https://github.com/nikolainobadi/NnGitKit) for Git operations  
- [NnSwiftDataKit](https://github.com/nikolainobadi/NnSwiftDataKit) for instantiating shared SwiftData container


