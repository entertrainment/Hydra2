//
//  DNSTunnelDetector.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//

import Foundation
import Combine

class DNSTunnelDetector: ObservableObject {
    @Published var suspiciousDomains: [String] = []
    private var timer: Timer?
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.scanDNS()
        }
        print("[DNSTunnelDetector] Monitoring started.")
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        print("[DNSTunnelDetector] Monitoring stopped.")
    }
    
    private func scanDNS() {
        let randomDomain = ["normal.com", "test.xyz", "tracker.base64", "safe.org"].randomElement()!
        if randomDomain.contains(".xyz") || randomDomain.contains("base64") {
            suspiciousDomains.append(randomDomain)
            print("[DNSTunnelDetector] Suspicious domain added: \(randomDomain)")
        }
    }
}
