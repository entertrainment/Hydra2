import Foundation
import Combine

struct SuricataAlert: Identifiable {
    let id = UUID()
    let category: String
    let message: String
    let sourceIP: String
    let destinationIP: String
    let severity: Int
    
    var color: String {
        switch severity {
        case 1: return "red"
        case 2: return "orange"
        case 3: return "yellow"
        default: return "gray"
        }
    }
    
    static func from(jsonLine: String) -> SuricataAlert? {
        guard let data = jsonLine.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let alert = obj["alert"] as? [String: Any],
              let category = alert["category"] as? String,
              let message = alert["signature"] as? String,
              let srcIP = obj["src_ip"] as? String,
              let dstIP = obj["dest_ip"] as? String,
              let severity = alert["severity"] as? Int else {
            return nil
        }
        return SuricataAlert(category: category, message: message, sourceIP: srcIP, destinationIP: dstIP, severity: severity)
    }
}

class SuricataFeedParser: ObservableObject {
    static let shared = SuricataFeedParser()
    @Published var alerts: [SuricataAlert] = []
    
    private let logPath = "/usr/local/var/log/suricata/eve.json"
    
    private init() {
        DispatchQueue.global(qos: .background).async {
            let process = Process()
            let pipe = Pipe()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
            process.arguments = ["tail", "-n", "100", "-F", self.logPath]
            process.standardOutput = pipe
            
            do {
                try process.run()
            } catch {
                print("[SuricataFeedParser] Failed to start tail process: \(error)")
                return
            }
            
            let handle = pipe.fileHandleForReading
            
            while let line = try? handle.readLine() {
                if let alert = SuricataAlert.from(jsonLine: line) {
                    DispatchQueue.main.async {
                        self.alerts.insert(alert, at: 0)
                        if self.alerts.count > 100 { self.alerts.removeLast() }
                    }
                }
            }
        }
    }
}
import Foundation

extension FileHandle {
    /// Reads the entire file content and returns an array of lines.
    func readAllLines() -> [String] {
        let data = self.readDataToEndOfFile()
        guard let content = String(data: data, encoding: .utf8) else { return [] }
        return content.components(separatedBy: .newlines)
    }
}

///class SuricataFeedParser {
///    func parseFile(atPath path: String) {
///        if let fileHandle = FileHandle(forReadingAtPath: path) {
///            let lines = fileHandle.readAllLines()
///            for line in lines {
///                print("[SuricataFeedParser] Parsed line: \(line)")
                // Further process each line as needed.
///            }
 ///       } else {
///            print("[SuricataFeedParser] Failed to open file at path: \(path)")
///        }
///    }
///}
