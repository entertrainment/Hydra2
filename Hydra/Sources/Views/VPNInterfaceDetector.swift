//
//  VPNDetectorInterface.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import Foundation
import Combine

class VPNInterfaceDetector: ObservableObject {
    @Published var alerts: [String] = []
    
    func scan() {
        let output = Shell.run("ifconfig")
        if output.contains("utun") {
            let alert = "VPN interface active."
            alerts.append(alert)
            print("[VPNInterfaceDetector] \(alert)")
        } else {
            print("[VPNInterfaceDetector] No VPN interfaces detected.")
        }
    }
}

