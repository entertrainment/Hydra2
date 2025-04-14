import SwiftUI

struct RSSIHeatmap: View {
    let clients: [Client]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Signal Heatmap")
                .font(.headline)
            GeometryReader { geo in
                ZStack {
                    ForEach(clients) { client in
                        Circle()
                            .fill(heatColor(for: client.rssi))
                            .frame(width: 20, height: 20)
                            .position(
                                x: CGFloat.random(in: 0...geo.size.width),
                                y: CGFloat.random(in: 0...geo.size.height)
                            )
                            .overlay(
                                Text(client.mac.prefix(5))
                                    .font(.system(size: 6))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
            .frame(height: 200)
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
        }
    }
    
    private func heatColor(for rssi: Int) -> Color {
        switch rssi {
        case ..<(-80): return .red
        case -80...(-60): return .orange
        case -60...(-40): return .yellow
        default: return .green
        }
    }
}
