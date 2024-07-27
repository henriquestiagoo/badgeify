#if canImport(AppKit)
import AppKit
#endif
import ArgumentParser
import Foundation
import PathKit

@preconcurrency @main
struct Badgeify: ParsableCommand {
    // an input path of the original icon
    @Option(name: .shortAndLong, transform: relativePath(from:))
    var input: Path

    // an output path, where the badge icon will be saved
    @Option(name: .shortAndLong, transform: relativePath(from:))
    var output: Path
    
    @Option
    var text: String

    func validate() throws {
        if text.isEmpty {
            throw ValidationError("Text cannot be empty")
        }
    }

    @MainActor mutating func run() throws {
        let imageData = try input.read()
        guard let originalIcon = NSImage(data: imageData) else {
            throw Error.invalidImageData
        }

        let badgedIcon = originalIcon.applyBadge(text: text)
        guard let badgedImageData = badgedIcon?.asPNGData else {
            throw Error.invalidImageData
        }

        try output.write(badgedImageData)

        print("Image successfully badged with \(text)")
    }
}
