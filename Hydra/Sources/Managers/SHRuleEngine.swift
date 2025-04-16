//
//  SHRuleEngine.swift
//  Hydra
//
//  Created by DH on 15/04/2025.
//
import Foundation
import Combine

class SHRuleEngine: ObservableObject {
    @Published var triggeredRules: [String] = []
    
    func load() {
        let message = "Loaded base ruleset."
        triggeredRules.append(message)
        print("[SHRuleEngine] \(message)")
    }
    
    func applyRules() {
        let triggered = "Rule X triggered."
        triggeredRules.append(triggered)
        print("[SHRuleEngine] \(triggered)")
    }
}

