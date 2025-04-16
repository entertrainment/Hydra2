//
//  NetworkClientDetector.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//

import Foundation
import Combine

struct NetworkClient: Identifiable {
    let id = UUID()
    let ip: String
    let mac: String
    let hostname: String
}

class NetworkClientDetector: ObservableObject {
    @Published var clients: [NetworkClient] = []
    
    func updateClients() {
        let output = Shell.run("arp -a")
        print("ARP output: \(output)")  // Log the raw output
        
        let regexPattern = #"(\d+\.\d+\.\d+\.\d+).*?(([0-9a-f:]{17}))"#

        var detected: [NetworkClient] = []
        if let regex = try? NSRegularExpression(pattern: regexPattern, options: .caseInsensitive) {
            let nsrange = NSRange(output.startIndex..<output.endIndex, in: output)
            regex.enumerateMatches(in: output, options: [], range: nsrange) { match, _, _ in
                if let match = match,
                   let ipRange = Range(match.range(at: 1), in: output),
                   let macRange = Range(match.range(at: 2), in: output) {
                    let ip = String(output[ipRange])
                    let mac = String(output[macRange])
                    // You might attempt reverse DNS lookup here to get the hostname, if desired.
                    let client = NetworkClient(ip: ip, mac: mac, hostname: "Unknown")
                    detected.append(client)
                }
            }
        }
        DispatchQueue.main.async {
            self.clients = detected
        }
        CentralLogger.shared.addLog("Network clients updated: \(detected.map { $0.ip }.joined(separator: ", "))")
    }
}
