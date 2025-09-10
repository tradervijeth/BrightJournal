//
//  JournalEntry.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import Foundation
import SwiftData

@Model
final class JournalEntry {
    var id: UUID
    var date: Date
    var rawText: String
    var reframedText: String?
    var moodTag: String?
    var moodScore: Double?
    var moodStickerData: Data? // For optional Image Playground stickers
    
    init(rawText: String, date: Date = Date()) {
        self.id = UUID()
        self.date = date
        self.rawText = rawText
        self.reframedText = nil
        self.moodTag = nil
        self.moodScore = nil
        self.moodStickerData = nil
    }
    
    // Computed property for display
    var displayText: String {
        return reframedText ?? rawText
    }
    
    // Simple on-device mood analysis based on keywords
    func analyzeMood() {
        let positiveWords = ["happy", "joy", "excited", "great", "amazing", "wonderful", "love", "peaceful", "grateful", "blessed", "fantastic", "awesome", "brilliant", "excellent", "thrilled"]
        let negativeWords = ["sad", "angry", "frustrated", "terrible", "awful", "hate", "depressed", "anxious", "worried", "stressed", "disappointed", "upset", "horrible", "miserable"]
        let neutralWords = ["okay", "fine", "normal", "regular", "usual", "average", "ordinary"]
        
        let textToAnalyze = (reframedText ?? rawText).lowercased()
        let words = textToAnalyze.components(separatedBy: .whitespacesAndNewlines)
        
        var positiveCount = 0
        var negativeCount = 0
        var neutralCount = 0
        
        for word in words {
            if positiveWords.contains(where: { word.contains($0) }) {
                positiveCount += 1
            } else if negativeWords.contains(where: { word.contains($0) }) {
                negativeCount += 1
            } else if neutralWords.contains(where: { word.contains($0) }) {
                neutralCount += 1
            }
        }
        
        // Determine dominant mood
        if positiveCount > negativeCount && positiveCount > neutralCount {
            self.moodTag = "positive"
            self.moodScore = min(1.0, Double(positiveCount) / Double(words.count) * 10)
        } else if negativeCount > positiveCount && negativeCount > neutralCount {
            self.moodTag = "negative"
            self.moodScore = max(-1.0, -Double(negativeCount) / Double(words.count) * 10)
        } else {
            self.moodTag = "neutral"
            self.moodScore = 0.0
        }
    }

    // Sample entry for previews
    static var sampleEntry: JournalEntry {
        let entry = JournalEntry(rawText: "Today was challenging. I struggled with a difficult project at work and felt overwhelmed by the deadlines.")
        entry.reframedText = "Today presented some challenges that helped me grow. I worked on a complex project that pushed my limits and reminded me of my resilience in facing demanding situations."
        entry.moodTag = "neutral"
        entry.moodScore = 0.2
        return entry
    }
}