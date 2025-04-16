//
//  EchoInjector.swift
//  Hydra
//
//  Created by DH on 15/04/2025.
//
import Foundation

class EchoInjector {
    private var timer: Timer?
    
    func startEchoPulse() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            let output = Shell.run("echo 'Sending echo pulse...'")
            print("[EchoInjector] \(output)")
        }
        print("[EchoInjector] Echo pulses started.")
    }
    
    func stopEchoPulse() {
        timer?.invalidate()
        timer = nil
        print("[EchoInjector] Echo pulses stopped.")
    }
}
