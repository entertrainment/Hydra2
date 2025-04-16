//
//  FlieAnalyzer.swift
//  Hydra
//
//  Created by DH on 15/04/2025.
//
import Foundation
import Combine

class FileAnalyzer: ObservableObject {
    @Published var results: [String] = []
    
    func startAnalysis() {
        let detection = Bool.random()
        let result = detection ? "Potential malware found in /tmp/fake_malware" : "No threats found."
        results.append(result)
        print("[FileAnalyzer] \(result)")
    }
}
