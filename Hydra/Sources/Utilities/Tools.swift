//
//  Tools.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import Foundation

// MARK: - RFJammer
class RFJammer {
    func jamNearby() {
        let output = Shell.run("echo 'Simulating RF Jammer... Jam Nearby'")
        print("[RFJammer] jamNearby output: \(output)")
    }
    
    func floodChannels(channels: [Int]) {
        let channelString = channels.map { String($0) }.joined(separator: ", ")
        let output = Shell.run("echo 'Flooding RF channels: \(channelString)'")
        print("[RFJammer] floodChannels output: \(output)")
    }
}

// MARK: - BLEFlooder
///class BLEFlooder {
///    func startFlooding() {
///        let output = Shell.run("echo 'Starting BLE Flooding...'")
///        print("[BLEFlooder] Flooding started: \(output)")
///    }
    
 ///   func stopFlooding() {
 ///       let output = Shell.run("echo 'Stopping BLE Flooding...'")
 ///       print("[BLEFlooder] Flooding stopped: \(output)")
 ///   }
    
    // For demonstration, a simple onStateChange handler.
 ///   var onStateChange: ((String) -> Void)?
///}

/// MARK: - ShadowUserJail
///class ShadowUserJail {
///    func spawnIsolatedUser() {
///        let msg = "Isolated user jail created."
///        let output = Shell.run("echo 'Simulating isolated user jail creation...'")
///        print("[ShadowUserJail] \(output)")
///        NotificationCenter.default.post(name: .JailUserEvent, object: msg)
///    }
///}

/// MARK: - StolenSessionBeacon
/// class StolenSessionBeacon {
///    func sendPing(to targetIP: String) {
///        let output = Shell.run("ping -c 1 \(targetIP)")
///        print("[StolenSessionBeacon] Ping output: \(output)")
///    }
    
///    func detectOutboundReplays() {
///        let output = Shell.run("echo 'Detecting outbound session replays...'")
///        print("[StolenSessionBeacon] \(output)")
///    }
///}

// MARK: - PacketSniffer
import Combine
class PacketSniffer: ObservableObject {
    @Published var capturedPackets: [String] = []
    
    private var task: Process?
    private var timer: Timer?
    
    private let logPath: String = {
        let fm = FileManager.default
        if let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
            return caches.appendingPathComponent("hydra_capture.log").path
        }
        return "/tmp/hydra_capture.log"
    }()
    
    func startCapture(filter: String = "") {
        try? FileManager.default.removeItem(atPath: logPath)
        let cmd = "sudo tcpdump -i en0 -l \(filter) > \(logPath)"
        task = Process()
        task?.executableURL = URL(fileURLWithPath: "/bin/bash")
        task?.arguments = ["-c", cmd]
        do {
            try task?.run()
            print("[PacketSniffer] tcpdump started.")
        } catch {
            print("[PacketSniffer] Failed to start: \(error.localizedDescription)")
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCapturedPackets()
        }
    }
    
    func stopCapture() {
        task?.terminate()
        timer?.invalidate()
        timer = nil
        print("[PacketSniffer] tcpdump terminated.")
    }
    
    private func updateCapturedPackets() {
        guard let raw = try? String(contentsOfFile: logPath, encoding: .utf8) else { return }
        DispatchQueue.main.async {
            self.capturedPackets = raw.split(separator: "\n").map(String.init)
        }
    }
}

// MARK: - SignalClassifier
class SignalClassifier {
    func predict(from features: [Double]) -> String {
        let sum = features.reduce(0, +)
        let prediction = sum > 2.0 ? "Malicious" : "Benign"
        print("[SignalClassifier] Features: \(features), Sum: \(sum), Prediction: \(prediction)")
        return prediction
    }
}

// MARK: - ActiveDefenseEngine
class ActiveDefenseEngine {
    func arpPoison(targetIP: String, spoofedMAC: String) {
        let result = Shell.run("sudo arp -s \(targetIP) \(spoofedMAC)")
        print("[ActiveDefenseEngine] ARP Poison result: \(result)")
    }
    
    func deauth(targetMAC: String, iface: String = "en0") {
        let result = Shell.run("sudo aireplay-ng --deauth 10 -a \(targetMAC) \(iface)")
        print("[ActiveDefenseEngine] Deauth result: \(result)")
    }
    
    func dnsRedirect(domain: String, toIP: String) {
        let entry = "\(toIP) \(domain)"
        do {
            try entry.appendLine(to: "/etc/hosts")
            print("[ActiveDefenseEngine] DNS redirect entry appended.")
        } catch {
            print("[ActiveDefenseEngine] DNS Redirect failed: \(error.localizedDescription)")
        }
    }
    
    func ban(mac: String) {
        let result = Shell.run("sudo ipfw add deny ip from any to any mac \(mac)")
        print("[ActiveDefenseEngine] Ban result: \(result)")
    }
    
    func unban(mac: String) {
        let result = Shell.run("sudo ipfw delete deny ip from any to any mac \(mac)")
        print("[ActiveDefenseEngine] Unban result: \(result)")
    }
    
    func cowrieRedirect(port: Int = 22) {
        let result = Shell.run("sudo ipfw add fwd 127.0.0.1,\(port) tcp from any to any dst-port 22")
        print("[ActiveDefenseEngine] Cowrie redirect result: \(result)")
    }
    
    func terminateAllRadios() {
        let out1 = Shell.run("sudo ifconfig en0 down")
        let out2 = Shell.run("sudo ifconfig awdl0 down")
        let out3 = Shell.run("sudo pkill -9 bluetoothd")
        print("[ActiveDefenseEngine] Terminate Radios: \(out1), \(out2), \(out3)")
    }
    
    // Additional client/interface controls.
    func disableInterface(interface: String) {
        let result = Shell.run("sudo ifconfig \(interface) down")
        print("[ActiveDefenseEngine] Disabled interface \(interface): \(result)")
    }
    
    func enableInterface(interface: String) {
        let result = Shell.run("sudo ifconfig \(interface) up")
        print("[ActiveDefenseEngine] Enabled interface \(interface): \(result)")
    }
    
    func banClient(ip: String) {
        let result = Shell.run("sudo ipfw add deny ip from \(ip) to any")
        print("[ActiveDefenseEngine] Ban client \(ip) result: \(result)")
    }
    
    func deauthClient(mac: String, iface: String = "en0") {
        deauth(targetMAC: mac, iface: iface)
    }
    
    func redirectClientTraffic(clientIP: String, honeypotIP: String, port: Int = 80) {
        let result = Shell.run("sudo ipfw add fwd \(honeypotIP),\(port) tcp from \(clientIP) to any")
        print("[ActiveDefenseEngine] Redirect client \(clientIP) to honeypot \(honeypotIP): \(result)")
    }
    
    func blackholeClientTraffic(clientIP: String) {
        let result = Shell.run("sudo ipfw add deny ip from \(clientIP) to any")
        print("[ActiveDefenseEngine] Blackholed client \(clientIP): \(result)")
    }
}

/// MARK: - RemoteObserver
///class RemoteObserver {
///    func startLANRelay() {
///        let output = Shell.run("echo 'Starting LAN relay observer...'")
///        print("[RemoteObserver] \(output)")
///    }
///}

/// MARK: - LogExport
///class LogExport {
///    func exportAsCSV() -> URL? {
///        print("[LogExport] Exporting logs as CSV...")
///        return URL(string: "file:///Users/Shared/hydra_logs.csv")
///    }
    
///    func exportAsPDF() -> URL? {
///        print("[LogExport] Exporting logs as PDF...")
///        return URL(string: "file:///Users/Shared/hydra_logs.pdf")
///    }
/// }

// MARK: - BLEFlooder
class BLEFlooder {
    func startFlooding() {
        let output = Shell.run("echo 'Starting BLE Flooding...'")
        print("[BLEFlooder] Flooding started: \(output)")
    }
    
    func stopFlooding() {
        let output = Shell.run("echo 'Stopping BLE Flooding...'")
        print("[BLEFlooder] Flooding stopped: \(output)")
    }
    
    var onStateChange: ((String) -> Void)?
}

