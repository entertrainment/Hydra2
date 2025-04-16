//
//  ThreatAIEngine.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import Foundation
import CoreML
import Combine

class ThreatAIEngine: ObservableObject {
    @Published var threatScore: Double = 0.0
    @Published var threatLabel: String = "Unknown"
    
    @Published var rssiAverage: Double = 0.0
    @Published var rssiStandardDeviation: Double = 0.0
    @Published var entropy: Double = 0.0
    
    func classifySignal(rssiSequence: [Int], packetSignatures: [String], domainPatterns: [String]) {
        guard !rssiSequence.isEmpty else {
            self.threatScore = 0.0
            self.threatLabel = "Insufficient Data"
            return
        }
        
        let avg = computeAverage(rssiSequence)
        let stDev = computeStandardDeviation(rssiSequence, average: avg)
        let computedEntropy = computeEntropy(rssiSequence)
        
        self.rssiAverage = avg
        self.rssiStandardDeviation = stDev
        self.entropy = computedEntropy
        
        let score = threatHeuristic(avg: avg,
                                    stDev: stDev,
                                    entropy: computedEntropy,
                                    signatures: packetSignatures,
                                    domains: domainPatterns)
        self.threatScore = score
        self.threatLabel = classify(score)
        print("[ThreatAIEngine] Classification complete. Score: \(score), Label: \(self.threatLabel)")
    }
    
    private func computeAverage(_ seq: [Int]) -> Double {
        let sum = seq.reduce(0, +)
        return Double(sum) / Double(seq.count)
    }
    
    private func computeStandardDeviation(_ seq: [Int], average: Double) -> Double {
        let sumSqDiffs = seq.map { pow(Double($0) - average, 2) }.reduce(0, +)
        return sqrt(sumSqDiffs / Double(seq.count))
    }
    
    private func computeEntropy(_ seq: [Int]) -> Double {
        guard seq.count >= 2 else { return 0.0 }
        let diffs = zip(seq, seq.dropFirst()).map { abs($0 - $1) }
        return Double(diffs.reduce(0, +)) / Double(diffs.count)
    }
    
    private func threatHeuristic(avg: Double,
                                 stDev: Double,
                                 entropy: Double,
                                 signatures: [String],
                                 domains: [String]) -> Double {
        var score = 0.0
        score += entropy / 100.0
        score += stDev / 100.0
        
        if signatures.contains(where: { $0.lowercased().contains("ff:ff:ff") || $0.lowercased().contains("dnslog") }) {
            score += 0.4
        }
        if domains.contains(where: { $0.lowercased().contains(".xyz") || $0.lowercased().contains("base64") }) {
            score += 0.3
        }
        if avg > -50 {
            score += 0.2
        }
        return min(score, 1.0)
    }
    
    private func classify(_ score: Double) -> String {
        switch score {
        case 0..<0.3: return "Low Risk"
        case 0.3..<0.7: return "Moderate Risk"
        default:       return "High Risk"
        }
    }
}

