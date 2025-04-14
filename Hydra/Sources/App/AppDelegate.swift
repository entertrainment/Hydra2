import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        _ = ConfigManager.shared
        ProcessMonitor.shared.monitorProcesses()
    }
}
