//
//  LaunchItemsMonitor.swift
//  Hydra
//
//  Created by DH on 16/04/2025.
//
import Foundation
import Combine

class LaunchItemsMonitor: ObservableObject {
    @Published var suspiciousItems: [String] = []
    
    func scanDirectory(_ directory: URL) {
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: directory.path)
            for file in files {
                // For demonstration, consider any file with "malicious" in its name as suspicious.
                if file.lowercased().contains("malicious") {
                    let fullPath = directory.appendingPathComponent(file).path
                    let message = "Suspicious launch item: \(fullPath)"
                    DispatchQueue.main.async {
                        self.suspiciousItems.append(message)
                        GlobalLogger.shared.addLog(message)
                    }
                }
            }
        } catch {
            GlobalLogger.shared.addLog("Error scanning \(directory.path): \(error.localizedDescription)")
        }
    }
    
    func scanAll() {
        let dirs = [
            URL(fileURLWithPath: "/Library/LaunchDaemons"),
            URL(fileURLWithPath: "/Library/LaunchAgents"),
            FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/LaunchAgents")
        ]
        for dir in dirs {
            scanDirectory(dir)
        }
    }
}
