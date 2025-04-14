import Foundation

class NetworkInterfaceManager {
    func listInterfaces() -> [String] {
        let output = Shell.run("networksetup -listallhardwareports")
        return output
            .components(separatedBy: .newlines)
            .filter { $0.contains("Device:") }
            .map { $0.replacingOccurrences(of: "Device: ", with: "").trimmingCharacters(in: .whitespaces) }
    }
    
    func enable(interface: String) {
        _ = Shell.run("sudo ifconfig \(interface) up")
    }
    
    func disable(interface: String) {
        _ = Shell.run("sudo ifconfig \(interface) down")
    }
}
