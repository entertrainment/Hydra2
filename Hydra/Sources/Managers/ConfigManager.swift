import Foundation

/// Loads configuration settings from a JSON file (Resources/config.json).
class ConfigManager {
    static let shared = ConfigManager()
    var config: [String: Any] = [:]
    
    init() {
        loadConfig()
    }
    
    private func loadConfig() {
        if let configPath = Bundle.main.path(forResource: "config", ofType: "json"),
           let data = try? Data(contentsOf: URL(fileURLWithPath: configPath)),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            config = json
        } else {
            config = defaultConfig()
        }
    }
    
    private func defaultConfig() -> [String: Any] {
        return [
            "remoteLogURL": "https://your.remote.server/logs",
            "threatThreshold": 0.75,
            "decoyRefreshInterval": 300,
            "enableRemoteLogging": true
        ]
    }
    
    func value<T>(for key: String) -> T? {
        return config[key] as? T
    }
}
