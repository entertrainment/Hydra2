import SwiftUI

struct JailControlPanel: View {
    @State private var logs: [String] = []
    @State private var filePath = ""
    let jail = ShadowUserJail()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Jail Session Control").font(.title2).bold()
            
            HStack {
                Button("Create Jail") { jail.spawnIsolatedUser() }
                Button("Kill Jail") { jail.killJailSession() }
                Button("Delete Jail") { jail.deleteJailUser() }
            }
            
            HStack {
                TextField("File to drop", text: $filePath)
                Button("Drop File") { jail.dropFileToJail(filePath: filePath) }
            }
            
            Divider()
            Text("Jail Logs").font(.headline)
            ScrollView {
                ForEach(logs, id: \.self) {
                    Text($0).font(.caption)
                }
            }
        }
        .padding()
        .onAppear {
            NotificationCenter.default.addObserver(forName: .JailUserEvent, object: nil, queue: .main) { note in
                if let msg = note.object as? String {
                    logs.append(msg)
                }
            }
        }
    }
}
