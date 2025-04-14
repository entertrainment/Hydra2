import Foundation

/// Periodically scans active processes for suspicious activity.
class ProcessMonitor {
    static let shared = ProcessMonitor()
    
    func monitorProcesses() {
        DispatchQueue.global(qos: .background).async {
            while true {
                let output = Shell.run("ps aux")
                if output.contains("suspicious_process") {
                    LoggingManager.shared.logEvent("Suspicious process detected: suspicious_process")
                }
                sleep(10)
            }
        }
    }
}
