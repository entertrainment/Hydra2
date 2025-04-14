import Foundation
import Combine

struct SuricataLogEntry: Identifiable, Decodable {
    let id = UUID()
    let event: String
    let source: String
    let destination: String
    let domain: String
    let query_type: String
}

class SuricataLogManager: ObservableObject {
    static let shared = SuricataLogManager()
    @Published var entries: [SuricataLogEntry] = []
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        let path = "/tmp/suricata_dns.json"
        DispatchQueue.global(qos: .background).async {
            while true {
                if let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
                   let decoded = try? JSONDecoder().decode([SuricataLogEntry].self, from: data) {
                    DispatchQueue.main.async {
                        self.entries = decoded
                    }
                }
                sleep(2)
            }
        }
    }
}
