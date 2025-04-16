
///    func redirectClientTraffic(clientIP: String, honeypotIP: String, port: Int) {
///        Shell.run("sudo ipfw add fwd \(honeypotIP),\(port) tcp from \(clientIP) to any dst-port \(port)")
// ActiveDefenseEngine.swift

//import Foundation
//
//class ActiveDefenseEngine {
//    // MARK: - Core Defensive Actions
//
//    func arpPoison(targetIP: String, spoofedMAC: String) {
//        let result = Shell.run("sudo arp -s \(targetIP) \(spoofedMAC)")
//        print("[ActiveDefenseEngine] ARP Poison result: \(result)")
//    }
//
//    func deauth(targetMAC: String, iface: String = "en0") {
//        let result = Shell.run("sudo aireplay-ng --deauth 10 -a \(targetMAC) \(iface)")
//        print("[ActiveDefenseEngine] Deauth result: \(result)")
//    }
//
//    func dnsRedirect(domain: String, toIP: String) {
//        let entry = "\(toIP) \(domain)"
//        do {
//            try entry.appendLine(to: "/etc/hosts")
//            print("[ActiveDefenseEngine] DNS redirect entry appended.")
//        } catch {
//            print("[ActiveDefenseEngine] DNS Redirect failed: \(error.localizedDescription)")
//        }
//    }
//
//    func ban(mac: String) {
//        let result = Shell.run("sudo ipfw add deny ip from any to any mac \(mac)")
//        print("[ActiveDefenseEngine] Ban result: \(result)")
//    }
//
//    func unban(mac: String) {
//        let result = Shell.run("sudo ipfw delete deny ip from any to any mac \(mac)")
//        print("[ActiveDefenseEngine] Unban result: \(result)")
//    }
//
//    func cowrieRedirect(port: Int = 22) {
//        let result = Shell.run("sudo ipfw add fwd 127.0.0.1,\(port) tcp from any to any dst-port 22")
//        print("[ActiveDefenseEngine] Cowrie redirect result: \(result)")
//    }
//
//    func terminateAllRadios() {
//        let out1 = Shell.run("sudo ifconfig en0 down")
//        let out2 = Shell.run("sudo ifconfig awdl0 down")
//        let out3 = Shell.run("sudo pkill -9 bluetoothd")
//        print("[ActiveDefenseEngine] Terminate Radios: \(out1), \(out2), \(out3)")
//    }
//
//    // MARK: - Additional Client and Interface Control
//
//    func disableInterface(interface: String) {
//        let result = Shell.run("sudo ifconfig \(interface) down")
//        print("[ActiveDefenseEngine] Disabled interface \(interface): \(result)")
//    }
//
//    func enableInterface(interface: String) {
//        let result = Shell.run("sudo ifconfig \(interface) up")
//        print("[ActiveDefenseEngine] Enabled interface \(interface): \(result)")
//    }
//
//    func banClient(ip: String) {
//        let result = Shell.run("sudo ipfw add deny ip from \(ip) to any")
//        print("[ActiveDefenseEngine] Ban client \(ip) result: \(result)")
//    }
//
//    func deauthClient(mac: String, iface: String = "en0") {
//        deauth(targetMAC: mac, iface: iface)
//    }
//
//    func redirectClientTraffic(clientIP: String, honeypotIP: String, port: Int = 80) {
//        let result = Shell.run("sudo ipfw add fwd \(honeypotIP),\(port) tcp from \(clientIP) to any")
//        print("[ActiveDefenseEngine] Redirect client \(clientIP) to honeypot \(honeypotIP): \(result)")
//    }
//
//    func blackholeClientTraffic(clientIP: String) {
//        let result = Shell.run("sudo ipfw add deny ip from \(clientIP) to any")
//        print("[ActiveDefenseEngine] Blackholed client \(clientIP): \(result)")
//    }
//
//    // MARK: - Passive Monitoring
//
//    func initiatePassiveMonitoring(mac: String) {
//        let result = Shell.run("sudo tshark -i en0 -Y \"eth.src == \(mac)\" -a duration:30 -w /tmp/\(mac)_monitor.pcap")
//        print("[ActiveDefenseEngine] Passive monitoring initiated for MAC \(mac): \(result)")
//    }
//}
