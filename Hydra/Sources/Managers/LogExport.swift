//
//  LogExport.swift
//  Hydra
//
//  Created by DH on 14/04/2025.
//

import Foundation

    class LogExport {
    func exportAsCSV() -> URL? {
        print("[LogExport] Exporting logs as CSV...")
        return URL(string: "file:///Users/Shared/hydra_logs.csv")
    }
    
    func exportAsPDF() -> URL? {
        print("[LogExport] Exporting logs as PDF...")
        return URL(string: "file:///Users/Shared/hydra_logs.pdf")
    }
}
