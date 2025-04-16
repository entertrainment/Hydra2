import Foundation
import CoreBluetooth
import Combine

/// A model representing a discovered BLE device.
struct BLEDevice: Identifiable, Equatable {
    let id = UUID()
    let name: String?
    let identifier: UUID  // From CoreBluetooth.
    let rssi: Int
}

/// A real Bluetooth scanner that uses CoreBluetooth to discover devices.
class BluetoothScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
    @Published var detectedDevices: [BLEDevice] = []
    @Published var rssiHistory: [Int] = []
    
    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    /// Starts scanning for BLE peripherals.
    func startScan() {
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("[BluetoothScanner] Bluetooth not powered on; state: \(centralManager.state.rawValue)")
        }
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("[BluetoothScanner] Bluetooth not available; state: \(central.state.rawValue)")
        }
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        let device = BLEDevice(name: peripheral.name,
                               identifier: peripheral.identifier,
                               rssi: RSSI.intValue)
        DispatchQueue.main.async {
            self.detectedDevices.append(device)
            self.rssiHistory.append(RSSI.intValue)
        }
    }
}
