//
//  BehaviouralAnalyzer.swift
//  Hydra
//
//  Created by DH on 16/04/2025.
//
import Foundation
import Combine

class BehavioralAnalyzer: ObservableObject {
    @Published var alerts: [String] = []
    
    func reviewLogs(_ logs: [String]) {
        // For demonstration, if more than 5 log entries occur in 10 seconds, flag an anomaly.
        if logs.count > 5 {
            let alert = "Anomaly detected: High event frequency."
            DispatchQueue.main.async {
                self.alerts.append(alert)
                GlobalLogger.shared.addLog("BehavioralAnalyzer: \(alert)")
            }
        }
    }
}
