//
//  AIAvailability.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import Foundation

enum AIAvailability {
    static var isAvailable: Bool {
        if #available(iOS 18.0, *) {
            // Additional runtime checks can be added here as Apple exposes them
            // For now, we check iOS version as the primary gate
            return true
        }
        return false
    }
    
    static var unavailableMessage: String {
        "Apple Intelligence features require iOS 18+ on supported devices."
    }
}