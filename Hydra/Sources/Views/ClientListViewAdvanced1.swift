//
//  ClientListViewAdvanced.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
//import SwiftUI
//import Foundation
//import Network
//
//struct Client: Identifiable {
//    let id = UUID()
//    let name: String
//    let mac: String
//    let ip: String
//    let rssi: Int
//}
//
//struct ClientListViewAdvanced: View {
//    @StateObject var clientDetector = NetworkClientDetector()
//    @StateObject var defenseEngine = ActiveDefenseEngine()
//    @State private var logOutput: [String] = []
//    
//    var body: some View {
//        NavigationView {
//            List(clientDetector.clients) { client in
//                VStack(alignment: .leading) {
//                    Text(client.name)
//                        .font(.headline)
//                    Text("IP: \(client.ip)")
//                    Text("MAC: \(client.mac)")
//                }
//                .padding(4)
//                .contextMenu {
//                    Button("Ban") {
//                        defenseEngine.banClient(ip: client.ip)
//                        addLog("Ban command sent to \(client.mac)")
//                    }
//                    Button("Deauth") {
//                        defenseEngine.deauthClient(mac: client.mac)
//                        addLog("Deauth command sent to \(client.mac)")
//                    }
//                    Button("Redirect") {
//                        defenseEngine.redirectClientTraffic(clientIP: client.ip, honeypotIP: "10.0.0.2", port: 8080)
//                        addLog("Redirect command sent for \(client.ip)")
//                    }
//                    Button("Blackhole") {
//                        defenseEngine.blackholeClientTraffic(clientIP: client.ip)
//                        addLog("Blackhole command sent for \(client.ip)")
//                    }
//                }
//                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                    Button(role: .destructive) {
//                        defenseEngine.banClient(ip: client.ip)
//                        addLog("Ban command (swipe) sent to \(client.mac)")
//                    } label: {
//                        Label("Ban", systemImage: "hand.raised.fill")
//                    }
//                }
//            }
//            .navigationTitle("Network Clients")
//            .onAppear {
//                clientDetector.updateClients()
//            }
//            .toolbar {
//                Button(action: {
//                    clientDetector.updateClients()
//                    addLog("Client list refreshed.")
//                }, label: {
//                    Image(systemName: "arrow.clockwise")
//                })
//            }
//        }
//    }
//    
//    private func addLog(_ entry: String) {
//        let timestamp = ISO8601DateFormatter().string(from: Date())
//        let fullEntry = "[\(timestamp)] \(entry)"
//        logOutput.append(fullEntry)
//        print(fullEntry)
//    }
//}
//
//struct ClientListViewAdvanced_Previews: PreviewProvider {
//    static var previews: some View {
//        ClientListViewAdvanced()
//    }
//}
//
