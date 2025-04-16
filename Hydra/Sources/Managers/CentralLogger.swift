//
//  CentralLogger.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import Foundation
import Combine

class CentralLogger: ObservableObject {
    static let shared = CentralLogger()
    
    @Published var logs: [String] = []
    private let logFilePath: String = {
        let fm = FileManager.default
        if let caches = fm.urls(for: .cachesDirectory, in: .userDomainMask).first {
            return caches.appendingPathComponent("central_logs.txt").path
        }
        return "/tmp/central_logs.txt"
    }()
    
    private init() {
        if let existing = try? String(contentsOfFile: logFilePath, encoding: .utf8) {
            logs = existing.components(separatedBy: "\n")
        }
    }
    
    func addLog(_ entry: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        let fullEntry = "[\(timestamp)] \(entry)"
        logs.append(fullEntry)
        NotificationCenter.default.post(name: .CentralLogDidUpdate, object: fullEntry)
        do {
            try fullEntry.appendLine(to: logFilePath)
        } catch {
            print("[CentralLogger] Failed to write log: \(error.localizedDescription)")
        }
    }
}

