//
//  NetworkInterfaceMonitor.swift
//  Hydra
//
//  Created by DH on 15/04/2025.
//
import Foundation
import Combine

class NetworkInterfaceMonitor: ObservableObject {
    @Published var activeInterfaces: [String] = []
    
    func updateInterfaces() {
        let output = Shell.run("ifconfig -l")
        activeInterfaces = output.split(separator: " ").map(String.init)
        print("[NetworkInterfaceMonitor] Active interfaces: \(activeInterfaces)")
    }
}

