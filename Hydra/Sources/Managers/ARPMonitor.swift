import Foundation

class ARPMonitor {
    private var knownTable: [String: String] = [:]
    
    func checkTable() {
        let output = Shell.run("arp -a")
        let lines = output.split(separator: "\n")
        for line in lines {
            if let ip = String(line).slice(from: "(", to: ")"),
               let mac = String(line).slice(from: "at ", to: " on") {
                if let knownMAC = knownTable[ip], knownMAC != mac {
                    logThreat("MAC change for \(ip): \(knownMAC) -> \(mac)")
                }
                knownTable[ip] = mac
            }
        }
    }
    
    private func logThreat(_ msg: String) {
        print("[ARPMonitor] \(msg)")
        try? "[ARPMonitor] \(msg)".appendLine(to: "/tmp/arp_threats.log")
        NotificationCenter.default.post(name: .SignalHydraThreatAlert, object: msg)
    }
}
