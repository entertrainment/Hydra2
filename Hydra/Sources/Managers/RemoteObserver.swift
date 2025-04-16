//
//  RemoteObserver.swift
//  Hydra
//
//  Created by DH on 15/04/2025.
//
import Foundation
import Network

class RemoteObserver {
    private var listener: NWListener?

    func startLANRelay(port: UInt16 = 5555) {
        do {
            let parameters = NWParameters.tcp
            listener = try NWListener(using: parameters, on: NWEndpoint.Port(rawValue: port)!)
            listener?.newConnectionHandler = { conn in
                conn.start(queue: .main)
                self.sendStatus(to: conn)
            }
            listener?.start(queue: .main)
        } catch {
            print("Relay launch failed: \(error)")
        }
    }

    private func sendStatus(to conn: NWConnection) {
        let message = "[Hydra Relay] Status: LIVE\nThreats: ACTIVE\n"
        conn.send(content: message.data(using: .utf8), completion: .contentProcessed({ _ in }))
    }

    func stopRelay() {
        listener?.cancel()
    }
}

    func startLANRelay() {
    let output = Shell.run("echo 'Starting LAN relay observer...'")
    print("[RemoteObserver] \(output)")
    }


