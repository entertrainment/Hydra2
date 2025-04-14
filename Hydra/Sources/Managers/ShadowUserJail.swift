import Foundation
import Cocoa

class ShadowUserJail {
    private let jailUser = "hydra_jail"
    private let jailHome = "/Users/hydra_jail"
    
    func spawnIsolatedUser() {
        let result = Shell.run("sudo sysadminctl -addUser \(jailUser) -home \(jailHome) -password HydraJail123! -admin")
        let msg = "[Jail] Created user \(jailUser): \(result)"
        NotificationCenter.default.post(name: .JailUserEvent, object: msg)
    }
    
    func dropFileToJail(filePath: String) {
        let result = Shell.run("sudo cp \(filePath) \(jailHome)/Downloads/")
        let msg = "[Jail] Dropped file into jail: \(result)"
        NotificationCenter.default.post(name: .JailUserEvent, object: msg)
    }
    
    func killJailSession() {
        let result = Shell.run("sudo pkill -u \(jailUser)")
        let msg = "[Jail] Terminated jail session: \(result)"
        NotificationCenter.default.post(name: .JailUserEvent, object: msg)
    }
    
    func deleteJailUser() {
        let result = Shell.run("sudo sysadminctl -deleteUser \(jailUser)")
        let msg = "[Jail] Deleted jail user: \(result)"
        NotificationCenter.default.post(name: .JailUserEvent, object: msg)
    }
}
