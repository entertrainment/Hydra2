import SwiftUI

@main
struct SignalHydraApp: App {
    var body: some Scene {
        WindowGroup {
            ClientListView(clients: ["AA:BB:CC:DD:EE:FF", "11:22:33:44:55:66"])
        }
    }
}
