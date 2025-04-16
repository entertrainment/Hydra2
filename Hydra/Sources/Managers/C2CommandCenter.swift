//
//  C2CommandCentre.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import SwiftUI

struct C2CommandCenter: View {
    @State private var c2Log: [String] = []
    @State private var c2Command: String = ""
    
    var body: some View {
        VStack {
            Text("C2 Command Center")
                .font(.largeTitle)
                .padding()
            
            HStack {
                TextField("Enter C2 command", text: $c2Command)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send Command") {
                    let response = Shell.run(c2Command)
                    c2Log.append("Sent: \(c2Command)")
                    c2Log.append("Response: \(response)")
                    c2Command = ""
                }
            }
            .padding()
            
            ScrollView {
                ForEach(c2Log, id: \.self) { logEntry in
                    Text(logEntry)
                        .font(.caption)
                        .padding(2)
                }
            }
            .frame(maxHeight: 300)
            
            Spacer()
        }
        .padding()
    }
}

