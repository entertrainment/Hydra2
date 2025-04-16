//
//  FileIntegrityMonitor.swift
//  Hydra
//
//  Created by DH on 16/04/2025.
//
import Foundation
import Combine

class FileIntegrityMonitor: ObservableObject {
    @Published var fileEvents: [String] = []
    private var source: DispatchSourceFileSystemObject?
    private var monitoredURL: URL?
    
    func startMonitoring(directory: URL) {
        monitoredURL = directory
        let fileDescriptor = open(directory.path, O_EVTONLY)
        guard fileDescriptor >= 0 else {
            GlobalLogger.shared.addLog("Error opening \(directory.path) for monitoring.")
            return
        }
        
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: DispatchQueue.global())
        source?.setEventHandler { [weak self] in
            let event = "Directory \(directory.path) modified."
            DispatchQueue.main.async {
                self?.fileEvents.append(event)
                GlobalLogger.shared.addLog("FileIntegrityMonitor: \(event)")
            }
        }
        source?.setCancelHandler {
            close(fileDescriptor)
        }
        source?.resume()
        
        GlobalLogger.shared.addLog("Started file integrity monitoring on \(directory.path)")
    }
    
    func stopMonitoring() {
        source?.cancel()
        source = nil
        if let url = monitoredURL {
            GlobalLogger.shared.addLog("Stopped file integrity monitoring on \(url.path)")
        }
    }
}
