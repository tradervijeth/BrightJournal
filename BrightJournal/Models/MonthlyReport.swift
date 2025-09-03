//
//  MonthlyReport.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import Foundation
import SwiftData

@Model
final class MonthlyReport {
    var id: UUID
    var month: Date // First day of the month
    var summary: String
    var themes: [String]
    var entryCount: Int
    var averageMoodScore: Double?
    
    init(month: Date, summary: String, themes: [String], entryCount: Int, averageMoodScore: Double? = nil) {
        self.id = UUID()
        self.month = month
        self.summary = summary
        self.themes = themes
        self.entryCount = entryCount
        self.averageMoodScore = averageMoodScore
    }
    
    var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: month)
    }
}