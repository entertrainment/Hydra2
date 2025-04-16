////
////  PacketSniffer.swift
////  Hydra
////
////  Created by DH on 15/04/2025.
////
//import Foundation
//import Combine
//
//class PacketSniffer: ObservableObject {
//    @Published var capturedPackets: [String] = []
//    
//    private var task: Process?
//    private var timer: Timer?
//    
//    private let logPath: String = {
//        let fm = FileManager.default
//        if let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
//            return caches.appendingPathComponent("hydra_capture.log").path
//        }
//        return "/tmp/hydra_capture.log"
//    }()
//    
//    func startCapture(filter: String = "") {
//        try? FileManager.default.removeItem(atPath: logPath)
//        let cmd = "sudo tcpdump -i en0 -l \(filter) > \(logPath)"
//        task = Process()
//        task?.executableURL = URL(fileURLWithPath: "/bin/bash")
//        task?.arguments = ["-c", cmd]
//        
//        do {
//            try task?.run()
//            print("[PacketSniffer] tcpdump started.")
//        } catch {
//            print("[PacketSniffer] Failed to start: \(error.localizedDescription)")
//        }
//        
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
//            self?.updateCapturedPackets()
//        }
//    }
//    
//    func stopCapture() {
//        task?.terminate()
//        timer?.invalidate()
//        timer = nil
//        print("[PacketSniffer] tcpdump terminated.")
//    }
//    
//    private func updateCapturedPackets() {
//        guard let raw = try? String(contentsOfFile: logPath, encoding: .utf8) else { return }
//        DispatchQueue.main.async {
//            self.capturedPackets = raw.split(separator: "\n").map(String.init)
//        }
//    }
//}
//
