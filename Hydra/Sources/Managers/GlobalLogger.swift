//
//  GlobalLogger.swift
//  Hydra
//
//  Created by DH on 16/04/2025.
//
import Foundation
import Combine

class GlobalLogger: ObservableObject {
    static let shared = GlobalLogger()
    
    @Published var logs: [String] = []
    
    func addLog(_ message: String) {
        let entry = "[\(ISO8601DateFormatter().string(from: Date()))] \(message)"
        DispatchQueue.main.async {
            self.logs.append(entry)
        }
        print(entry)
    }
}
