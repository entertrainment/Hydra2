import SwiftUI

struct LiveLogConsole: View {
    @Binding var logs: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Live System Logs")
                .font(.headline)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(logs.indices, id: \.self) { i in
                            Text(logs[i])
                                .font(.system(.caption, design: .monospaced))
                                .id(i)
                        }
                    }
                    .onChange(of: logs.count) { _ in
                        withAnimation {
                            proxy.scrollTo(logs.count - 1, anchor: .bottom)
                        }
                    }
                }
            }
            .frame(maxHeight: 200)
            .padding()
            .background(Color.black.opacity(0.9))
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.green.opacity(0.4)))
        }
        .padding()
    }
}
