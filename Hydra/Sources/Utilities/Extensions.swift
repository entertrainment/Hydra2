import Foundation

extension String {
    /// Appends this string as a new line to the file at the given path.
    func appendLine(to path: String) throws {
        let line = self + "\n"
        if FileManager.default.fileExists(atPath: path) {
            if let fileHandle = FileHandle(forWritingAtPath: path) {
                fileHandle.seekToEndOfFile()
                if let data = line.data(using: .utf8) {
                    fileHandle.write(data)
                }
                fileHandle.closeFile()
            }
        } else {
            try line.write(toFile: path, atomically: true, encoding: .utf8)
        }
    }
    
    /// Returns the substring between two delimiters.
    func slice(from: String, to: String) -> String? {
        guard let start = range(of: from)?.upperBound,
              let end = range(of: to, range: start..<endIndex)?.lowerBound else { return nil }
        return String(self[start..<end])
    }
}
