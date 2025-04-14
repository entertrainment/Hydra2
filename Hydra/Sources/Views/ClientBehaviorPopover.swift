import SwiftUI

struct ClientBehaviorPopover: View {
    let macAddress: String
    @State private var profile: BehaviorProfile?
    
    var body: some View {
        VStack(alignment: .leading) {
            if let profile = profile {
                Text("Behavior Profile for \(profile.client_mac)")
                    .font(.headline)
                Divider()
                List(profile.events) { event in
                    HStack {
                        Image(systemName: iconName(for: event.type))
                            .foregroundColor(color(for: event.type))
                        VStack(alignment: .leading) {
                            Text(event.timestamp)
                                .font(.caption)
                            Text(event.message)
                        }
                    }
                }
            } else {
                Text("Loading profile...")
                    .onAppear {
                        loadProfile()
                    }
            }
        }
        .padding()
        .frame(width: 300, height: 400)
    }
    
    func loadProfile() {
        let path = "/tmp/client_profiles/\(macAddress).json"
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            let decoder = JSONDecoder()
            if let loadedProfile = try? decoder.decode(BehaviorProfile.self, from: data) {
                self.profile = loadedProfile
            }
        }
    }
    
    func iconName(for type: String) -> String {
        switch type {
        case "alert": return "exclamationmark.triangle"
        case "scan": return "magnifyingglass"
        case "honeypot": return "lock.shield"
        case "action": return "bolt"
        default: return "questionmark.circle"
        }
    }
    
    func color(for type: String) -> Color {
        switch type {
        case "alert": return .red
        case "scan": return .blue
        case "honeypot": return .orange
        case "action": return .yellow
        default: return .gray
        }
    }
}
