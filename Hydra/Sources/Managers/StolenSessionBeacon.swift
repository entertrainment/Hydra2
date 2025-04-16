//
//  StolenSessionBeacon.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//

import Foundation

class StolenSessionBeacon {
    func sendPing(to targetIP: String) {
        let output = Shell.run("ping -c 1 \(targetIP)")
        print("[StolenSessionBeacon] Ping output: \(output)")
    }
    
    func detectOutboundReplays() {
        let output = Shell.run("echo 'Detecting outbound session replays...'")
        print("[StolenSessionBeacon] \(output)")
    }
}
