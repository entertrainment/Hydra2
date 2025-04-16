////
////  CombinedBluetoothScanner.swift
////  Hydra
////
////  Created by DH on 15/04/2025.
////
//import Foundation
//import CoreBluetooth
//import Combine
//
//// MARK: - Shared Model
//
///// A model representing a discovered BLE device.
//struct BLEDevice: Identifiable, Equatable {
//    let id = UUID()
//    let name: String?
//    let identifier: UUID   // Unique identifier from CoreBluetooth.
//    let rssi: Int
//}
//
//// MARK: - BluetoothScanning Protocol
//
//protocol BluetoothScanning: ObservableObject {
//    var detectedDevices: [BLEDevice] { get }
//    var rssiHistory: [Int] { get }
//    func startScan()
//}
//
//// MARK: - Real Bluetooth Scanner
//
//class RealBluetoothScanner: NSObject, BluetoothScanning, CBCentralManagerDelegate {
//    @Published var detectedDevices: [BLEDevice] = []
//    @Published var rssiHistory: [Int] = []
//    
//    private var centralManager: CBCentralManager!
//    
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
//    
//    func startScan() {
//        if centralManager.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: nil, options: nil)
//        } else {
//            print("[RealBluetoothScanner] Bluetooth not powered on. State: \(centralManager.state)")
//        }
//    }
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: nil, options: nil)
//        } else {
//            print("[RealBluetoothScanner] Bluetooth not available. State: \(central.state)")
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager,
//                        didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String : Any],
//                        rssi RSSI: NSNumber) {
//        let device = BLEDevice(name: peripheral.name,
//                               identifier: peripheral.identifier,
//                               rssi: RSSI.intValue)
//        DispatchQueue.main.async {
//            self.detectedDevices.append(device)
//            self.rssiHistory.append(RSSI.intValue)
//        }
//    }
//}
//
//// MARK: - Simulated Bluetooth Scanner
//
//class SimulatedBluetoothScanner: BluetoothScanning {
//    @Published var detectedDevices: [BLEDevice] = []
//    @Published var rssiHistory: [Int] = []
//    
//    func startScan() {
//        // Simulate scanning by adding some sample devices.
//        let device1 = BLEDevice(name: "Simulated Device 1", identifier: UUID(), rssi: -45)
//        let device2 = BLEDevice(name: "Simulated Device 2", identifier: UUID(), rssi: -60)
//        detectedDevices = [device1, device2]
//        rssiHistory = [device1.rssi, device2.rssi]
//        print("[SimulatedBluetoothScanner] Simulated scan completed: \(detectedDevices)")
//    }
//}
//
