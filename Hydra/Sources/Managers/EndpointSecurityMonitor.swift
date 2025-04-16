import Foundation
import EndpointSecurity
import Combine

// Use a unique logger to avoid conflicts
class AnomalyLogger {
    static let shared = AnomalyLogger()
    private init() {}
    
    func addLog(_ message: String) {
        let entry = "[\(ISO8601DateFormatter().string(from: Date()))] \(message)"
        print(entry)
    }
}

/// A fully functional Endpoint Security monitor using the EndpointSecurity C API.
/// This implementation subscribes to exec and create notifications.
class EndpointSecurityMonitor: ObservableObject {
    @Published var events: [String] = []
    private var client: OpaquePointer!  // Force unwrapped after creation
    
    init() {
        // Create the Endpoint Security client.
        let result = es_new_client(&client) { (client, messagePtr) in
            // Get the message, which is of type es_message_t.
            let message = messagePtr.pointee
            var eventDescription = "Event Unknown"
            
            // Handle process execution event.
            if message.event_type == ES_EVENT_TYPE_NOTIFY_EXEC {
                // Access the exec part directly (without '.data') since the Swift binding exposes it this way.
                if let targetPointer = message.exec.target,
                   let pathPtr = targetPointer.pointee.path {
                    eventDescription = "Exec: \(String(cString: pathPtr))"
                } else {
                    eventDescription = "Exec: Unknown target"
                }
            }
            // Handle file creation event.
            else if message.event_type == ES_EVENT_TYPE_NOTIFY_CREATE {
                if let destinationPointer = message.create.destination,
                   let pathPtr = destinationPointer.pointee.path {
                    eventDescription = "Create: \(String(cString: pathPtr))"
                } else {
                    eventDescription = "Create: Unknown destination"
                }
            }
            else {
                eventDescription = "Event type \(message.event_type.rawValue)"
            }
            
            DispatchQueue.main.async {
                AnomalyLogger.shared.addLog("EndpointSecurity: \(eventDescription)")
            }
        }
        
        if result != errSecSuccess {
            AnomalyLogger.shared.addLog("Failed to create EndpointSecurity client: \(result)")
        } else {
            // Subscribe to the desired events
            let eventsToSubscribe: [es_event_type_t] = [ES_EVENT_TYPE_NOTIFY_EXEC, ES_EVENT_TYPE_NOTIFY_CREATE]
            let subscribeResult = es_subscribe(client!, eventsToSubscribe, UInt32(eventsToSubscribe.count))
            // Compare subscribeResult directly to 0 (success).
            if subscribeResult != 0 {
                AnomalyLogger.shared.addLog("Failed to subscribe: \(subscribeResult)")
            } else {
                AnomalyLogger.shared.addLog("EndpointSecurityMonitor initialized and subscribed.")
            }
        }
    }
    
    deinit {
        if client != nil {
            es_delete_client(client)
        }
    }
    
    func startMonitoring() {
        AnomalyLogger.shared.addLog("EndpointSecurityMonitor started.")
    }
    
    func stopMonitoring() {
        if client != nil {
            es_delete_client(client)
            client = nil
        }
        AnomalyLogger.shared.addLog("EndpointSecurityMonitor stopped.")
    }
}
