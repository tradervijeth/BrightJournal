//
//  AIAvailability.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import Foundation
import FoundationModels

struct AIAvailability {
    /// Checks if Apple Intelligence Foundation Models are available
    static var isAvailable: Bool {
        let model = SystemLanguageModel.default
        
        switch model.availability {
        case .available:
            return true
        case .unavailable(_):
            return false
        }
    }
    
    /// Gets a user-friendly message about AI availability status
    static var statusMessage: String {
        let model = SystemLanguageModel.default
        
        switch model.availability {
        case .available:
            return "Apple Intelligence is ready"
        case .unavailable(.appleIntelligenceNotEnabled):
            return "Please enable Apple Intelligence in Settings"
        case .unavailable(.modelNotReady):
            return "Apple Intelligence is preparing..."
        case .unavailable(.deviceNotEligible):
            return "This device doesn't support Apple Intelligence"
        case .unavailable(_):
            return "Apple Intelligence is not available"
        }
    }
}