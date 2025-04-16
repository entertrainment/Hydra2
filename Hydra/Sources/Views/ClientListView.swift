import SwiftUI

struct ClientListView: View {
    // Declare clients as a constant so that Swift generates a memberwise initializer.
    let clients: [Client]
    
    // Provide a default value in the initializer.
    init(clients: [Client] = [
        Client(name: "SuspiciousClient1", mac: "AA:BB:CC:DD:EE:FF", ip: "192.168.0.105", rssi: -45),
        Client(name: "UnknownNode",       mac: "11:22:33:44:55:66", ip: "192.168.0.88", rssi: -67)
    ]) {
        self.clients = clients
    }
    
    @State private var selectedCommand: String = ""
    @State private var logOutput: [String] = []
    @State private var threatLevelFilter: String = "All"
    
    let c2Commands: [String] = [
        "Deauth", "Ban", "Unban", "Redirect to Cowrie", "Blackhole Traffic",
        "DNS Redirect", "Run Nmap OS Scan", "RSSI Track", "Passive Monitor",
        "Send Beacon", "Terminate Radios", "Suricata Alert Scan", "AI Threat Analysis"
    ]
    
    let threatLevels = ["All", "Low", "Medium", "High"]
    
    var body: some View {
        VStack {
            Text("Connected Clients")
                .font(.title)
                .bold()
            
            Picker("Filter by Threat", selection: $threatLevelFilter) {
                ForEach(threatLevels, id: \.self) { level in
                    Text(level)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.bottom)
            
            ScrollView {
                ForEach(filteredClients()) { client in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(client.name) - \(client.mac) (\(client.ip))")
                            .font(.subheadline)
                        
                        Text("RSSI: \(client.rssi)")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                Button("Ban") {
                                    log("Ban command sent to \(client.mac)")
                                    Shell.run("sudo ipfw add deny ip from any to any mac \(client.mac)")
                                }
                                Button("Unban") {
                                    log("Unban command sent to \(client.mac)")
                                    Shell.run("sudo ipfw delete deny ip from any to any mac \(client.mac)")
                                }
                                Button("Deauth") {
                                    log("Deauth command sent to \(client.mac)")
                                    Shell.run("sudo aireplay-ng --deauth 10 -a \(client.mac) en0")
                                }
                                Button("Cowrie") {
                                    log("Cowrie honeypot redirect for \(client.ip)")
                                    Shell.run("sudo ipfw add fwd 127.0.0.1,2222 tcp from \(client.ip) to any dst-port 22")
                                }
                                Button("Blackhole") {
                                    log("Blackhole route for \(client.ip)")
                                    Shell.run("sudo ipfw add deny ip from \(client.ip) to any")
                                }
                            }
                        }
                        
                        HStack {
                            Picker("Command", selection: $selectedCommand) {
                                ForEach(c2Commands, id: \.self) { cmd in
                                    Text(cmd).tag(cmd)
                                }
                            }
                            .frame(width: 200)
                            
                            Button("Run C2") {
                                runCommand(selectedCommand, for: client)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                }
            }
            
            Divider()
            Text("Log Output")
                .font(.headline)
            ScrollView {
                ForEach(logOutput, id: \.self) { line in
                    Text(line)
                        .font(.caption)
                        .padding(.vertical, 1)
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
    
    private func runCommand(_ command: String, for client: Client) {
        switch command {
        case "Ban":
            Shell.run("sudo ipfw add deny ip from any to any mac \(client.mac)")
        case "Unban":
            Shell.run("sudo ipfw delete deny ip from any to any mac \(client.mac)")
        case "Deauth":
            Shell.run("sudo aireplay-ng --deauth 10 -a \(client.mac) en0")
        case "Redirect to Cowrie":
            Shell.run("sudo ipfw add fwd 127.0.0.1,2222 tcp from \(client.ip) to any dst-port 22")
        case "Blackhole Traffic":
            Shell.run("sudo ipfw add deny ip from \(client.ip) to any")
        case "DNS Redirect":
            let entry = "127.0.0.1 intercepted.io"
            try? entry.appendLine(to: "/etc/hosts")
        case "Run Nmap OS Scan":
            Shell.run("sudo nmap -O \(client.ip)")
        case "RSSI Track":
            log("Tracking RSSI for \(client.mac) - RSSI: \(client.rssi)")
        case "Passive Monitor":
            log("Initiated passive monitoring on \(client.mac)")
        case "Send Beacon":
            Shell.run("curl -X POST http://\(client.ip):8080/beacon")
        case "Terminate Radios":
            Shell.run("sudo ifconfig en0 down; sudo pkill -9 bluetoothd")
        case "Suricata Alert Scan":
            Shell.run("sudo suricata -r /tmp/hydra_capture.pcap -l /tmp/suricata_alerts/")
            log("Suricata alert scan started for \(client.ip)")
        case "AI Threat Analysis":
            log("AI threat prediction running for \(client.ip) with RSSI \(client.rssi)...")
            let risk = Double(client.rssi + 100) / 100.0
            if risk > 0.75 {
                log("** AI THREAT ALERT: Potentially compromised node — \(client.mac)")
            } else {
                log("AI scan indicates normal behavior for \(client.mac)")
            }
        default:
            log("Unknown command: \(command)")
        }
        log("[C2] \(command) executed for \(client.mac)")
    }
    
    private func log(_ line: String) {
        logOutput.append(line)
        try? line.appendLine(to: "/tmp/hydra_c2.log")
    }
    
    private func filteredClients() -> [Client] {
        return clients.filter { client in
            let score = mockThreatScore(for: client)
            switch threatLevelFilter {
            case "Low": return score < 0.3
            case "Medium": return score >= 0.3 && score < 0.7
            case "High": return score >= 0.7
            default: return true
            }
        }
    }
    
    private func mockThreatScore(for client: Client) -> Double {
        return Double(abs(client.mac.hashValue % 100)) / 100.0
    }
}

struct ClientListView_Previews: PreviewProvider {
    static var previews: some View {
        ClientListView(clients: [
            Client(name: "SuspiciousClient1", mac: "AA:BB:CC:DD:EE:FF", ip: "192.168.0.105", rssi: -45),
            Client(name: "UnknownNode", mac: "11:22:33:44:55:66", ip: "192.168.0.88", rssi: -67)
        ])
    }
}
