//
//  ContentView.swift
//  Hydra
//
//  Created by DH on 16/04/2025.
//
import SwiftUI

struct ContentView: View {
    @StateObject var endpointMonitor = EndpointSecurityMonitor()
    @StateObject var fileMonitor = FileIntegrityMonitor()
    @StateObject var launchMonitor = LaunchItemsMonitor()
    @StateObject var dtraceMonitor = DTraceMonitor()
    @StateObject var behavioralAnalyzer = BehavioralAnalyzer()
    @StateObject var logger = GlobalLogger.shared
    
    // Timer for behavioral reviews
    @State private var reviewTimer: Timer?
    
    var body: some View {
        TabView {
            // Endpoint Security Tab
            VStack(alignment: .leading) {
                Text("Endpoint Security")
                    .font(.title2).bold()
                List(endpointMonitor.events, id: \.self) { event in
                    Text(event)
                        .font(.caption)
                }
            }
            .tabItem {
                Label("Endpoint", systemImage: "desktopcomputer")
            }
            .onAppear { endpointMonitor.startMonitoring() }
            .onDisappear { endpointMonitor.stopMonitoring() }
            
            // File Integrity Tab
            VStack(alignment: .leading) {
                Text("File Integrity")
                    .font(.title2).bold()
                List(fileMonitor.fileEvents, id: \.self) { event in
                    Text(event)
                        .font(.caption)
                }
                HStack {
                    Button("Start Monitoring ~/Library/Caches") {
                        let cachesURL = FileManager.default.homeDirectoryForCurrentUser
                            .appendingPathComponent("Library/Caches")
                        fileMonitor.startMonitoring(directory: cachesURL)
                    }
                    Button("Stop Monitoring") {
                        fileMonitor.stopMonitoring()
                    }
                }
            }
            .tabItem {
                Label("Files", systemImage: "folder")
            }
            
            // Launch Items Tab
            VStack(alignment: .leading) {
                Text("Launch Items")
                    .font(.title2).bold()
                List(launchMonitor.suspiciousItems, id: \.self) { item in
                    Text(item)
                        .font(.caption)
                }
                Button("Scan Launch Items") {
                    launchMonitor.scanAll()
                }
            }
            .tabItem {
                Label("Launch", systemImage: "bolt.horizontal")
            }
            
            // DTrace/Network Tab
            VStack(alignment: .leading) {
                Text("DTrace & Network")
                    .font(.title2).bold()
                List(dtraceMonitor.dtraceEvents, id: \.self) { event in
                    Text(event)
                        .font(.caption)
                }
                HStack {
                    Button("Start DTrace Monitor") {
                        dtraceMonitor.startMonitoring()
                    }
                    Button("Stop DTrace Monitor") {
                        dtraceMonitor.stopMonitoring()
                    }
                }
            }
            .tabItem {
                Label("DTrace", systemImage: "network")
            }
            
            // Behavioral Analysis Tab
            VStack(alignment: .leading) {
                Text("Behavioral Analysis")
                    .font(.title2).bold()
                List(behavioralAnalyzer.alerts, id: \.self) { alert in
                    Text(alert)
                        .font(.caption)
                }
            }
            .tabItem {
                Label("Behavior", systemImage: "exclamationmark.triangle")
            }
            
            // Central Log Tab
            VStack(alignment: .leading) {
                Text("Central Log")
                    .font(.title2).bold()
                List(logger.logs, id: \.self) { log in
                    Text(log)
                        .font(.caption)
                }
            }
            .tabItem {
                Label("Log", systemImage: "text.alignleft")
            }
        }
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            // Set up timer to periodically review logs for anomalies.
            reviewTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
                behavioralAnalyzer.reviewLogs(logger.logs)
            }
        }
        .onDisappear {
            reviewTimer?.invalidate()
            reviewTimer = nil
        }
    }
}
