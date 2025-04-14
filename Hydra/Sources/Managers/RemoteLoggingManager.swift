import Foundation
import os.log

/// Manages remote offloading of log entries.
class RemoteLoggingManager {
    static let shared = RemoteLoggingManager()
    let logger = OSLog(subsystem: "com.entertrainment.SignalHydra", category: "RemoteLogging")
    
    func offloadLog(_ logEntry: String) {
        guard let urlString: String = ConfigManager.shared.value(for: "remoteLogURL"),
              let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = logEntry.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                os_log("Remote logging error: %@", log: self.logger, type: .error, error.localizedDescription)
            }
        }
        task.resume()
    }
}
