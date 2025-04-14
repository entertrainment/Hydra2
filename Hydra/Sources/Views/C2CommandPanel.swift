import SwiftUI

struct C2CommandPanel: View {
    let clientMAC: String
    let clientIP: String
    @State private var selectedCommand: String = ""
    @State private var showCommands = false
    @State private var commandLog: [String] = []
    
    let commands: [String] = [
        "Ban Client",
        "Unban Client",
        "Deauth (aircrack-ng)",
        "DNS Redirect (Hole)",
        "Cowrie Redirect",
        "Run Nmap Scan"
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Button("Open C2 Command List") {
                showCommands.toggle()
            }
            .padding(.vertical, 4)
            
            if showCommands {
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack {
                        ForEach(commands, id: \.self) { command in
                            Button(command) {
                                runCommand(command)
                            }
                            .padding(6)
                            .background(Color.blue.opacity(0.2))
                            .cornerRadius(6)
                        }
                    }
                }
                Divider()
                Text("Command Log").font(.caption).bold()
                ScrollView {
                    ForEach(commandLog, id: \.self) { log in
                        Text(log).font(.caption2).padding(2)
                    }
                }
                .frame(height: 80)
            }
        }
        .padding()
    }
    
    private func runCommand(_ cmd: String) {
        let time = ISO8601DateFormatter().string(from: Date())
        var log = "[\(time)] "
        
        switch cmd {
        case "Ban Client":
            Shell.run("sudo ipfw add deny ip from any to any mac \(clientMAC)")
            log += "Banned MAC \(clientMAC)"
        case "Unban Client":
            Shell.run("sudo ipfw delete deny ip from any to any mac \(clientMAC)")
            log += "Unbanned MAC \(clientMAC)"
        case "Deauth (aircrack-ng)":
            Shell.run("sudo aireplay-ng --deauth 10 -a \(clientMAC) en0")
            log += "Deauth triggered for \(clientMAC)"
        case "DNS Redirect (Hole)":
            let entry = "127.0.0.1 evil.com"
            try? entry.appendLine(to: "/etc/hosts")
            log += "DNS Hole inserted"
        case "Cowrie Redirect":
            Shell.run("sudo ipfw add fwd 127.0.0.1,22 tcp from \(clientIP) to any dst-port 22")
            log += "Redirected \(clientIP) to local Cowrie honeypot"
        case "Run Nmap Scan":
            Shell.run("sudo nmap -O -sV \(clientIP)")
            log += "Nmap scan initiated for \(clientIP)"
        default:
            log += "Unknown command"
        }
        
        commandLog.append(log)
    }
}
