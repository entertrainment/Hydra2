//import Foundation
//import CoreBluetooth
//import Combine
//
//class BluetoothScanner: NSObject, ObservableObject, CBCentralManagerDelegate {
//    @Published var detectedDevices: [BLEDevice] = []
//    private var centralManager: CBCentralManager!
//    
//    override init() {
//        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
//    }
//    
//    func centralManagerDidUpdateState(_ central: CBCentralManager) {
//        if central.state == .poweredOn {
//            centralManager.scanForPeripherals(withServices: nil, options: nil)
//        }
//    }
//    
//    func centralManager(_ central: CBCentralManager,
//                        didDiscover peripheral: CBPeripheral,
//                        advertisementData: [String : Any],
//                        rssi RSSI: NSNumber) {
//        let device = BLEDevice(name: peripheral.name, identifier: peripheral.identifier, rssi: RSSI.intValue)
//        DispatchQueue.main.async {
//            self.detectedDevices.append(device)
//        }
//    }
//}
//
//extension BluetoothScanner {
//    struct BLEDevice: Identifiable {
//        let id = UUID()
//        let name: String?
//        let identifier: UUID
//        let rssi: Int
//    }
//}
