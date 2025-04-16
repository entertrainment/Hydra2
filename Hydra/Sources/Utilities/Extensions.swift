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

extension FileHandle {
    /// Reads a single line from the file and returns it as a String.
    /// Returns nil if at EOF.
    func readLine() throws -> String? {
        var buffer = Data()
        while true {
            // Read one byte at a time.
            guard let tempData = try self.read(upToCount: 1) else {
                // If there's nothing read and no data in the buffer, we've reached EOF.
                return buffer.isEmpty ? nil : String(data: buffer, encoding: .utf8)
            }
            
            // Break if we read an empty chunk.
            if tempData.isEmpty { break }
            
            // Check for newline character (ASCII 10).
            if tempData.first == 10 {
                break
            }
            
            // Append the byte to the buffer.
            buffer.append(tempData)
        }
        
        return String(data: buffer, encoding: .utf8)
    }
}

import Foundation

extension Notification.Name {
    static let JailUserEvent = Notification.Name("JailUserEvent")
    // Other notification keys can be added here if needed.
}

extension Notification.Name {
    static let SignalHydraThreatAlert = Notification.Name("SignalHydraThreatAlert")
}

extension Notification.Name {
    static let CentralLogDidUpdate = Notification.Name("CentralLogDidUpdate")
}

extension Notification.Name {
    static let BLEFlooderLog = Notification.Name("BLEFlooderLog")
}
