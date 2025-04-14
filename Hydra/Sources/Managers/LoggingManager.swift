import Foundation
import os.log

class LoggingManager {
    static let shared = LoggingManager()
    let logger = OSLog(subsystem: "com.entertrainment.SignalHydra", category: "Security")
    
    func logEvent(_ event: String) {
        let signed = signLogEntry(event)
        os_log("%@", log: logger, type: .info, signed)
        if let enableRemote: Bool = ConfigManager.shared.value(for: "enableRemoteLogging"),
           enableRemote {
            RemoteLoggingManager.shared.offloadLog(signed)
        }
    }
    
    private func signLogEntry(_ entry: String) -> String {
        return "signed(\(entry))"
    }
}
