import SwiftUI

struct SuricataLiveAlertView: View {
    @ObservedObject var logManager = SuricataLogManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Suricata DNS Alerts")
                .font(.headline)
                .padding(.top)
            
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(logManager.entries.reversed()) { entry in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Event: \(entry.event)")
                                .bold()
                            Text("Source: \(entry.source)")
                            Text("Destination: \(entry.destination)")
                            Text("Domain: \(entry.domain)")
                            Text("Type: \(entry.query_type)")
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(6)
                    }
                }
            }
        }
        .padding()
    }
}
