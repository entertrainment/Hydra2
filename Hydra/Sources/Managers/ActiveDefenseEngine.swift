import Foundation

class ActiveDefenseEngine {
    func redirectClientTraffic(clientIP: String, honeypotIP: String, port: Int) {
        Shell.run("sudo ipfw add fwd \(honeypotIP),\(port) tcp from \(clientIP) to any dst-port \(port)")
    }
}
