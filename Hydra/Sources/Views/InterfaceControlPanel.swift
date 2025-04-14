import SwiftUI

struct InterfaceControlPanel: View {
    @State private var interfaces: [String] = []
    @State private var toggled: [String: Bool] = [:]
    let manager = NetworkInterfaceManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Network Interfaces")
                .font(.headline)
            
            ForEach(interfaces, id: \.self) { iface in
                HStack {
                    Circle()
                        .fill((toggled[iface] ?? true) ? .green : .red)
                        .frame(width: 10, height: 10)
                    Text("\(iface)")
                        .font(.caption)
                        .bold()
                    Spacer()
                    Button((toggled[iface] ?? true) ? "Disable" : "Enable") {
                        toggled[iface]?.toggle()
                        if toggled[iface] ?? true {
                            manager.enable(interface: iface)
                        } else {
                            manager.disable(interface: iface)
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(6)
                .background((toggled[iface] ?? true) ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                .cornerRadius(6)
            }
        }
        .padding()
        .onAppear {
            interfaces = manager.listInterfaces()
            interfaces.forEach { toggled[$0] = true }
        }
    }
}
