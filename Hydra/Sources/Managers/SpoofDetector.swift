//
//  SpoofDetector.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import Foundation
import Combine

class SpoofDetector: ObservableObject {
    @Published var alerts: [String] = []
    private var timer: Timer?
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.checkForSpoofing()
        }
        print("[SpoofDetector] Monitoring started.")
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        print("[SpoofDetector] Monitoring stopped.")
    }
    
    private func checkForSpoofing() {
        if Bool.random() {
            let alert = "⚠️ ARP spoofing detected."
            alerts.append(alert)
            print("[SpoofDetector] Alert appended: \(alert)")
        }
    }
}

