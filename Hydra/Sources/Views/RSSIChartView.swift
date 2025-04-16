//
//  RSSIChartView.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//
import SwiftUI
import Charts

struct RSSIChartView: View {
    @ObservedObject var scanner: BluetoothScanner
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Live BLE RSSI Chart").font(.headline)
            if #available(iOS 16, macOS 13, *) {
                Chart {
                    ForEach(Array(scanner.rssiHistory.prefix(10).enumerated()), id: \.offset) { index, rssi in
                        BarMark(x: .value("Sample \(index)", index),
                                y: .value("RSSI", Double(rssi)))
                    }
                }
                .frame(height: 200)
            } else {
                Text("Chart not available on this OS version.")
            }
        }
        .padding()
    }
}

//import SwiftUI
//import Charts
//
//struct RSSIChartView: View {
//    @ObservedObject var scanner: any BluetoothScanning
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Live BLE RSSI Chart").font(.headline)
//            if #available(iOS 16, macOS 13, *) {
//                Chart {
//                    ForEach(Array(scanner.rssiHistory.prefix(10).enumerated()), id: \.offset) { index, rssi in
//                        BarMark(x: .value("Sample \(index)", index),
//                                y: .value("RSSI", Double(rssi)))
//                    }
//                }
//                .frame(height: 200)
//            } else {
//                Text("Chart not available on this OS version.")
//            }
//        }
//        .padding()
//    }
//}
