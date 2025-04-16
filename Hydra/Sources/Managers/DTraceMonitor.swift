//
//  DTraceMonitor.swift
//  Hydra
//
//  Created by DH on 16/04/2025.
//
import Foundation
import Combine

class DTraceMonitor: ObservableObject {
    @Published var dtraceEvents: [String] = []
    private var timer: Timer?
    
    func startMonitoring() {
        GlobalLogger.shared.addLog("DTraceMonitor started (simulated).")
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            let event = "Access to /dev/dtracehelper detected."
            DispatchQueue.main.async {
                self.dtraceEvents.append(event)
                GlobalLogger.shared.addLog("DTraceMonitor: \(event)")
            }
        }
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        GlobalLogger.shared.addLog("DTraceMonitor stopped.")
    }
}
