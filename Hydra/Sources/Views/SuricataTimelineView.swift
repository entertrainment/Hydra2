import SwiftUI

struct SuricataTimelineView: View {
    @ObservedObject var logManager = SuricataLogManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Suricata Timeline")
                    .font(.title2)
                    .bold()
                Spacer()
                Button("Export Log") {
                    export()
                }
            }
            
            List(logManager.entries) { alert in
                VStack(alignment: .leading) {
                    Text("Event: \(alert.event)").bold()
                    Text("From: \(alert.source) → \(alert.destination)")
                    Text("Domain: \(alert.domain), Type: \(alert.query_type)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(4)
            }
        }
        .padding()
    }
    
    func export() {
        let path = "/tmp/suricata_timeline_export.log"
        let entries = logManager.entries.map {
            "[\($0.event)] \($0.source) -> \($0.destination) | Domain: \($0.domain) | Type: \($0.query_type)"
        }.joined(separator: "\n")
        
        try? entries.appendLine(to: path)
        print("Exported Suricata log to \(path)")
    }
}
