import Foundation

class RuleEngine {
    private let defense = ActiveOffenseEngine()
    private let jail = ShadowUserJail()
    
    func evaluate(threatScore: Double, rssiEntropy: Double, domainHits: [String], mac: String) {
        if threatScore > 0.8 || rssiEntropy > 20 {
            log("HIGH RISK — Executing ban & kill radios")
            defense.ban(mac: mac)
            defense.terminateAllRadios()
        }
        if domainHits.contains(where: { $0.contains("dnslog") || $0.contains(".xyz") }) {
            log("Suspicious DNS — Cowrie redirect")
            defense.cowrieRedirect()
        }
        if threatScore > 0.5 && domainHits.isEmpty {
            log("Medium threat — DNS hole insert")
            defense.dnsRedirect(domain: "intercepted.io", toIP: "127.0.0.1")
        }
        if rssiEntropy > 15 && threatScore < 0.5 {
            log("Anomalous RSSI detected — Sending to jail")
            jail.spawnIsolatedUser()
            jail.dropFileToJail(filePath: "/tmp/\(mac)_quarantine.log")
        }
    }
    
    private func log(_ entry: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        try? "[\(timestamp)] \(entry)".appendLine(to: "/tmp/hydra_events.log")
    }
}
