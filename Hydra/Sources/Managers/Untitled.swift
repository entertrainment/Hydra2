
import Foundation
import Combine
import CoreBluetooth

struct BluetoothDevice: Identifiable, Equatable {
    let id = UUID()
    let name: String?
    let identifier: String
    let rssi: Int
}

class BluetoothScanner: ObservableObject {
    @Published var activeInterfaces: [String] = []
    @Published var detectedDevices: [BluetoothDevice] = []
    @Published var rssiHistory: [Int] = []
    
    func startScan() {
        // Simulate interfaces for demonstration.
        activeInterfaces = ["en0", "awdl0"]
        
        // Simulate BLE devices.
        let device1 = BluetoothDevice(name: "Device 1", identifier: "abc", rssi: -45)
        let device2 = BluetoothDevice(name: "Device 2", identifier: "def", rssi: -60)
        detectedDevices = [device1, device2]
        
        // Build RSSI history from detected devices.
        rssiHistory = detectedDevices.map { $0.rssi }
        
        print("[BluetoothScanner] Scan started. Detected devices: \(detectedDevices)")
    }
}
import Foundation
import CoreBluetooth
import Combine

class RealBluetoothScanner: NSObject, BluetoothScanning, CBCentralManagerDelegate {
    @Published var detectedDevices: [BLEDevice] = []
    @Published var rssiHistory: [Int] = []
    
    private var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScan() {
        // Start scanning if Bluetooth is powered on.
        if centralManager.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth is not available. State: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device = BLEDevice(name: peripheral.name, identifier: peripheral.identifier, rssi: RSSI.intValue)
        DispatchQueue.main.async {
            self.detectedDevices.append(device)
            self.rssiHistory.append(RSSI.intValue)
        }
    }
}
