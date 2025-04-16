import SwiftUI

struct CommandCenterView: View {
    @StateObject var netMonitor = NetworkInterfaceMonitor()
    @StateObject var bleScanner = BluetoothScanner()
    @StateObject var spoofDetector = SpoofDetector()
    @StateObject var dnsTunnel = DNSTunnelDetector()
    @StateObject var packetSniffer = PacketSniffer()
    @StateObject var vpnScanner = VPNInterfaceDetector()
    @StateObject var fileAnalyzer = FileAnalyzer()
    @StateObject var aiEngine = ThreatAIEngine()
    @StateObject var shre = SHRuleEngine()
    @StateObject var clientDetector = NetworkClientDetector()
    
    @State private var echoInjector = EchoInjector()
    @State private var defense = ActiveDefenseEngine()
    @State private var rules = RuleEngine()
    @State private var exporter = LogExport()
    @State private var observer = RemoteObserver()
    @State private var vault = VaultManager()
    
    @State private var exportedURL: URL?
    @State private var targetMAC = ""
    @State private var targetIP = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Signal Hydra: Command & Control Center")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text("Network Interfaces").bold()
                            List(netMonitor.activeInterfaces, id: \.self) { iface in
                                Text(iface)
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("BLE Devices").bold()
                            List(bleScanner.detectedDevices) { device in
                                Button(action: {
                                    CentralLogger.shared.addLog("Selected device \(device.name ?? "Unknown")")
                                }) {
                                    Text("\(device.name ?? "Unknown") — RSSI: \(device.rssi)")
                                }
                            }
                            RSSIChartView(scanner: bleScanner)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Alerts").bold()
                            List(spoofDetector.alerts + vpnScanner.alerts, id: \.self) {
                                Text($0)
                            }
                            List(dnsTunnel.suspiciousDomains, id: \.self) {
                                Text($0)
                            }
                            List(fileAnalyzer.results, id: \.self) {
                                Text($0)
                            }
                            List(shre.triggeredRules, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        // Since ClientListView now has a default initializer,
                        // this NavigationLink will use the default sample clients.
                        NavigationLink("Show Client List", destination: ClientListView())
                        NavigationLink("Open C2 Command Center", destination: C2CommandCenter())
                    }
                    .padding()
                    
                    VStack {
                        HStack {
                            TextField("Target MAC", text: $targetMAC)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            TextField("Target IP", text: $targetIP)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        .padding()
                        
                        HStack {
                            Button("Run Ruleset") {
                                let domainHits = dnsTunnel.suspiciousDomains
                                let entropy = aiEngine.entropy
                                rules.evaluate(threatScore: aiEngine.threatScore,
                                               rssiEntropy: entropy,
                                               domainHits: domainHits,
                                               mac: targetMAC)
                                shre.applyRules()
                                CentralLogger.shared.addLog("Ruleset executed.")
                            }
                            Button("Export Logs as CSV") {
                                exportedURL = exporter.exportAsCSV()
                                CentralLogger.shared.addLog("CSV exported to: \(exportedURL?.path ?? "N/A")")
                            }
                            Button("Export Logs as PDF") {
                                exportedURL = exporter.exportAsPDF()
                                CentralLogger.shared.addLog("PDF exported to: \(exportedURL?.path ?? "N/A")")
                            }
                            Button("Run Threat Classifier") {
                                aiEngine.classifySignal(rssiSequence: bleScanner.rssiHistory,
                                                        packetSignatures: packetSniffer.capturedPackets,
                                                        domainPatterns: dnsTunnel.suspiciousDomains)
                            }
                        }
                        .padding()
                        
                        HStack {
                            Button("Start Spoof + Sniff") {
                                bleScanner.startScan()
                                netMonitor.updateInterfaces()
                                spoofDetector.startMonitoring()
                                dnsTunnel.startMonitoring()
                                packetSniffer.startCapture()
                                echoInjector.startEchoPulse()
                                observer.startLANRelay()
                                shre.load()
                                vpnScanner.scan()
                                clientDetector.updateClients()
                                CentralLogger.shared.addLog("Spoof + Sniff started.")
                            }
                            Button("Kill Radios") {
                                defense.terminateAllRadios()
                                CentralLogger.shared.addLog("Radios terminated.")
                            }
                        }
                        .padding()
                    }
                    
                    Text("Classifier Result: \(aiEngine.threatLabel) (Score: \(String(format: "%.2f", aiEngine.threatScore)))")
                        .padding()
                    
                    Divider()
                    Text("Central Log")
                        .font(.headline)
                    ScrollView {
                        ForEach(CentralLogger.shared.logs, id: \.self) { logEntry in
                            Text(logEntry)
                                .font(.caption)
                                .padding(2)
                        }
                    }
                    .frame(maxHeight: 300)
                    
                    Spacer()
                }
            }
            .onAppear {
                netMonitor.updateInterfaces()
                bleScanner.startScan()
            }
            .navigationTitle("Command Center")
        }
    }
}
