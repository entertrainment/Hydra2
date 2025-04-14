import Foundation
import os.log

class DecoyManager {
    let fileManager = FileManager.default
    let logger = LoggingManager.shared
    let decoyDirectory: URL = {
        let tempDir = FileManager.default.temporaryDirectory
        return tempDir.appendingPathComponent("DecoyFiles")
    }()
    
    init() {
        try? fileManager.createDirectory(at: decoyDirectory, withIntermediateDirectories: true)
    }
    
    func createDecoyFile(named fileName: String) {
        let fileURL = decoyDirectory.appendingPathComponent(fileName)
        let fakeContent = "Sensitive data: [REDACTED] \(Date())"
        do {
            try fakeContent.write(to: fileURL, atomically: true, encoding: .utf8)
            logger.logEvent("Created decoy file: \(fileName)")
        } catch {
            os_log("Error creating decoy file: %@", type: .error, error.localizedDescription)
        }
    }
    
    func monitorDecoyDirectory() {
        let descriptor = open(decoyDirectory.path, O_EVTONLY)
        let source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: descriptor, eventMask: .write, queue: DispatchQueue.global())
        source.setEventHandler { [weak self] in
            self?.logger.logEvent("Decoy directory modified.")
        }
        source.setCancelHandler {
            close(descriptor)
        }
        source.resume()
    }
}
