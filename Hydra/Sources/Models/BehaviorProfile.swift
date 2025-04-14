import Foundation

struct BehaviorEvent: Identifiable, Decodable {
    let id = UUID()
    let timestamp: String
    let source: String
    let type: String
    let message: String
}

struct BehaviorProfile: Decodable {
    let client_mac: String
    let events: [BehaviorEvent]
}
