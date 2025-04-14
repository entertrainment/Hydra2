import Foundation

struct Client: Identifiable {
    let id = UUID()
    let name: String
    let mac: String
    let ip: String
    let rssi: Int
    var timestamp: Date = .now
    var rssiHistory: [RSSIPoint] = []
    
    mutating func updateRSSI(_ newRSSI: Int) {
        rssiHistory.append(RSSIPoint(time: Date(), value: newRSSI))
        if rssiHistory.count > 30 { rssiHistory.removeFirst() }
    }
}

struct RSSIPoint: Identifiable {
    let id = UUID()
    let time: Date
    let value: Int
}
