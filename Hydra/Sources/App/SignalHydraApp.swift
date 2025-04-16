import SwiftUI

/// @main
struct SignalHydraApp: App {
    var body: some Scene {
        WindowGroup {
            // Pass an array of Client objects (not strings).
            ClientListView(clients: [
                Client(name: "SuspiciousClient1", mac: "AA:BB:CC:DD:EE:FF", ip: "192.168.0.105", rssi: -45),
                Client(name: "UnknownNode", mac: "11:22:33:44:55:66", ip: "192.168.0.88", rssi: -67)
            ])
        }
    }
}
