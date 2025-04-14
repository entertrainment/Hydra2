# SignalHydra

SignalHydra is an advanced security/deception framework for macOS built in Swift. It integrates real‑time client monitoring, dynamic command‑and‑control (C2) interfaces, active offense/defense measures, decoy management, AI‑based anomaly detection, and event processing from IDS tools such as Suricata and Cowrie honeypots.

## Advanced Features
- **Real‑Time Monitoring & C2:** Manage connected clients (Wi‑Fi, BLE) with a dynamic C2 dashboard.
- **Active Defense/Offense:** Conduct reverse ARP poisoning, SYN floods, beacon spoofing, MAC rotation, and more.
- **AI‑Enhanced Threat Analysis:** Utilize CoreML to score anomalous behavior and trigger defensive actions.
- **Dynamic Configuration:** Load configuration settings from JSON to tailor behavior in real time.
- **Robust Logging:** Integrate local logging, cryptographic signing (via SEP/Keychain), and enhanced remote log offloading.

## Project Structure

SignalHydra/
├── README.md
├── LICENSE
├── .gitignore
├── SignalHydra.xcodeproj      (Created by Xcode)
├── Sources/
│   ├── App/
│   │   ├── SignalHydraApp.swift
│   │   └── AppDelegate.swift
│   ├── Models/
│   │   ├── Client.swift
│   │   └── BehaviorProfile.swift
│   ├── Views/
│   │   ├── C2CommandPanel.swift
│   │   ├── ClientListView.swift
│   │   ├── LiveLogConsole.swift
│   │   ├── BLEChartView.swift
│   │   ├── RSSIHeatmap.swift
│   │   ├── InterfaceControlPanel.swift
│   │   ├── JailControlPanel.swift
│   │   ├── SuricataLiveAlertView.swift
│   │   ├── SuricataTimelineView.swift
│   │   └── ClientBehaviorPopover.swift
│   ├── Managers/
│   │   ├── Shell.swift
│   │   ├── LoggingManager.swift
│   │   ├── DecoyManager.swift
│   │   ├── NetworkInterfaceManager.swift
│   │   ├── ARPMonitor.swift
│   │   ├── SuricataLogManager.swift
│   │   ├── SuricataFeedParser.swift
│   │   ├── RuleEngine.swift
│   │   ├── ActiveOffenseEngine.swift
│   │   ├── ActiveDefenseEngine.swift
│   │   ├── ShadowUserJail.swift
│   │   ├── BluetoothScanner.swift
│   │   ├── AnomalyDetector.swift
│   │   ├── ConfigManager.swift
│   │   ├── RemoteLoggingManager.swift
│   │   └── ProcessMonitor.swift
│   ├── Utilities/
│   │   └── Extensions.swift
│   └── Supporting Files/
│       └── Constants.swift
├── Scripts/
│   ├── disk_setup.sh
│   ├── trap_killall.c
│   └── rsync_trap.c
├── Cowrie/
│   ├── command_spin.py
│   └── command_trampoline.py
└── Resources/
    ├── config.json
    ├── known_binaries.json
    ├── pf_rules/
    │   ├── hydra_rules.txt
    │   └── hydra_pf.conf
    └── Suricata/
        ├── eve.json
        └── sample_suricata_events.json

## Getting Started

1. Clone the repository.
2. Open the Xcode project.
3. Compile and run on an M3 MBP running macOS Sequoia.
4. Refer to Resources/config.json for configurable parameters.
