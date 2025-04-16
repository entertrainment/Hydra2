//
//  HydraDashBoardView.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import SwiftUI
import Foundation


struct HydraDashboardView: View {
    @State private var logOutput: [String] = []
    @State private var targetMAC = ""
    @State private var targetIP = ""
    @State private var isFlooding = false
    @State private var currentSpoofName = "–"
    @State private var currentSpoofUUID = "–"
    @State private var bluetoothStatus = "Unknown"
    
    private let jammer = RFJammer()
    private let flooder = BLEFlooder()
    private let jail = ShadowUserJail()
    private let beacon = StolenSessionBeacon()
    private let sniffer = PacketSniffer()
    private let classifier = SignalClassifier()
    private let defense = ActiveDefenseEngine()
    private let observer = RemoteObserver()
    private let export = LogExport()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("SignalHydra Control Panel")
                    .font(.largeTitle)
                    .bold()
                
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("BLE Spoof Name: \(currentSpoofName)")
                            .font(.caption)
                        Text("BLE UUID: \(currentSpoofUUID)")
                            .font(.caption)
                        Text("Bluetooth Status: \(bluetoothStatus)")
                            .font(.caption)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack {
                    TextField("Target MAC", text: $targetMAC)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Target IP", text: $targetIP)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                ScrollView(.vertical) {
                    VStack(spacing: 12) {
                        Button(isFlooding ? "Stop BLE Flooder" : "Start BLE Flooder") {
                            if isFlooding {
                                flooder.stopFlooding()
                                logOutput.append("BLE Flooder stopped.")
                            } else {
                                flooder.startFlooding()
                                logOutput.append("BLE Flooder started.")
                            }
                            isFlooding.toggle()
                        }
                        Button("Start RF Jammer") {
                            jammer.jamNearby()
                            logOutput.append("RF Jammer triggered.")
                        }
                        Button("Jam RF Channels") {
                            jammer.floodChannels(channels: [1, 6, 11])
                            logOutput.append("RF channels flooded on [1,6,11].")
                        }
                        Button("Spawn Jail User") {
                            jail.spawnIsolatedUser()
                            logOutput.append("Isolated jail user created.")
                        }
                        Button("Send Beacon Ping") {
                            beacon.sendPing(to: targetIP)
                            logOutput.append("Beacon ping sent to \(targetIP)")
                        }
                        Button("Start Packet Sniffing") {
                            sniffer.startCapture()
                            logOutput.append("Packet sniffer started.")
                        }
                        Button("Stop Sniffing") {
                            sniffer.stopCapture()
                            logOutput.append("Packet sniffer stopped.")
                        }
                        Button("Classify Threat") {
                            let result = classifier.predict(from: [0.98, 0.85, 0.1, 0.02])
                            logOutput.append("Classifier Result: \(result)")
                        }
                        Button("Terminate Radios") {
                            defense.terminateAllRadios()
                            logOutput.append("Radios terminated.")
                        }
                        Button("Cowrie Redirect") {
                            defense.cowrieRedirect()
                            logOutput.append("Cowrie redirect activated.")
                        }
                        Button("Export CSV") {
                            if let url = export.exportAsCSV() {
                                logOutput.append("Exported CSV to: \(url.path)")
                            }
                        }
                        Button("Export PDF") {
                            if let url = export.exportAsPDF() {
                                logOutput.append("Exported PDF to: \(url.path)")
                            }
                        }
                    }
                }
                .padding()
                
                Divider()
                Text("Log Output")
                    .font(.headline)
                ScrollView {
                    ForEach(logOutput, id: \.self) { logEntry in
                        Text(logEntry)
                            .font(.caption)
                            .padding(2)
                    }
                }
                .frame(maxHeight: 200)
                
                Spacer()
            }
            .padding()
            .onAppear {
                flooder.onStateChange = { state in
                    DispatchQueue.main.async {
                        bluetoothStatus = state
                    }
                }
                NotificationCenter.default.addObserver(forName: .BLEFlooderLog,
                                                       object: nil,
                                                       queue: .main) { notification in
                    if let msg = notification.object as? String {
                        logOutput.append(msg)
                        if msg.contains("Advertising as") {
                            let parts = msg.components(separatedBy: "Advertising as ")
                            if parts.count > 1 {
                                let comps = parts[1].components(separatedBy: " with UUID ")
                                if comps.count == 2 {
                                    currentSpoofName = comps[0]
                                    currentSpoofUUID = comps[1]
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Countermeasure Dashboard")
        }
    }
}

