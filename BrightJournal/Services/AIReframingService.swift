//
//  AIReframingService.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import Foundation
import SwiftUI
import FoundationModels

@MainActor
class AIReframingService: ObservableObject {
    
    enum ReframeError: Error, LocalizedError {
        case textTooShort
        case processingFailed
        case appleIntelligenceNotEnabled
        case modelNotReady
        case contextWindowExceeded
        
        var errorDescription: String? {
            switch self {
            case .textTooShort:
                return "Please enter at least 10 characters to reframe"
            case .processingFailed:
                return "Failed to reframe text. Please try again."
            case .appleIntelligenceNotEnabled:
                return "Please enable Apple Intelligence in Settings to use AI reframing."
            case .modelNotReady:
                return "The AI model is downloading or preparing. Please try again in a moment."
            case .contextWindowExceeded:
                return "Text is too long for processing. Please try with shorter text."
            }
        }
    }
    
    /// Reframes negative or neutral text into a more positive, growth-oriented perspective using Apple Intelligence
    func reframeText(_ originalText: String) async throws -> String {
        // Validate input
        let trimmedText = originalText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedText.count >= 10 else {
            throw ReframeError.textTooShort
        }
        
        // Get the system language model
        let model = SystemLanguageModel.default
        
        // Check model availability - this app requires Apple Intelligence
        switch model.availability {
        case .available:
            break // Continue with processing
        case .unavailable(.appleIntelligenceNotEnabled):
            throw ReframeError.appleIntelligenceNotEnabled
        case .unavailable(.modelNotReady):
            throw ReframeError.modelNotReady
        case .unavailable(_):
            throw ReframeError.processingFailed
        }
        
        // Create expert CBT therapist instructions
        let instructions = Instructions("""
        You are an expert cognitive behavioral therapist and positive psychology coach with 20+ years of experience. Your role is to help people reframe negative thoughts into more balanced, growth-oriented perspectives using evidence-based CBT techniques.

        When someone shares negative thoughts or experiences, you should:
        1. Acknowledge their feelings with genuine empathy and validation
        2. Identify specific cognitive distortions (all-or-nothing thinking, catastrophizing, mind reading, fortune telling, etc.)
        3. Gently challenge and reframe the situation using CBT techniques to show:
           - Learning opportunities and personal growth potential
           - Alternative perspectives and evidence-based thinking
           - Resilience-building aspects of the experience
        4. Maintain a warm, supportive, and hopeful tone throughout
        5. Keep responses concise but meaningful (similar length to original)
        6. Focus on empowerment, self-compassion, and future possibilities

        Your reframes should feel authentic and grounded, never dismissive of real challenges. Help them see their experiences through a lens of growth, resilience, and self-discovery while honoring their emotional experience.
        """)
        
        // Create a session with the expert instructions
        let session = LanguageModelSession(instructions: instructions)
        
        // Create the therapeutic reframing prompt
        let prompt = Prompt("""
        Please provide a therapeutic reframe for this thought or experience. Transform it into a more balanced, growth-oriented perspective while fully acknowledging the person's feelings:

        "\(trimmedText)"

        Provide only the reframed version as if you're speaking directly to the person. Keep it roughly the same length as the original.
        """)
        
        // Configure generation options for empathetic but creative responses
        let options = GenerationOptions(temperature: 0.8)
        
        do {
            // Generate the professional therapeutic reframe
            let response = try await session.respond(to: prompt, options: options)
            
            // Return the AI-generated reframe, cleaned up
            return response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            
        } catch LanguageModelSession.GenerationError.exceededContextWindowSize(_) {
            throw ReframeError.contextWindowExceeded
        } catch {
            // If Foundation Models fail for any reason, rethrow as processing failed
            throw ReframeError.processingFailed
        }
    }
}