//
//  BluetoothProximityMonitor.swift
//  Hydra
//
//  Created by DH on 15/04/2025.
//
import CoreBluetooth
import Foundation

class BluetoothProximityMonitor: NSObject, CBCentralManagerDelegate {
    private var manager: CBCentralManager!
    private let targetName = "HydraActivator"
    private let unlockCallback: () -> Void

    init(unlockCallback: @escaping () -> Void) {
        self.unlockCallback = unlockCallback
        super.init()
        manager = CBCentralManager(delegate: self, queue: .main)
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            manager.scanForPeripherals(withServices: nil, options: nil)
        }
    }

    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        if peripheral.name == targetName {
            unlockCallback()
            manager.stopScan()
        }
    }
}
