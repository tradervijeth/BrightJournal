//
//  MonthlySummaryPreviewView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI
import SwiftData

struct MonthlySummaryPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    
    let entries: [JournalEntry]
    let selectedMonth: Date
    let existingReport: MonthlyReport?
    let onSave: (MonthlyReport) -> Void
    
    @State private var summaryText: String = ""
    @State private var themes: [String] = []
    @State private var editingThemes = false
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Generate Monthly Summary")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("1. Review your entries below\n2. Select all text and tap ••• \n3. Choose 'Summarize' from the menu\n4. Edit themes and save when ready")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                    
                    if !AIAvailability.isAvailable {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .foregroundColor(.orange)
                            Text(AIAvailability.statusMessage)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding(.horizontal)
                
                // Combined entries text for summarization
                VStack(alignment: .leading, spacing: 8) {
                    Text("Journal entries for \(monthFormatter.string(from: selectedMonth)):")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    WritingToolsTextView(
                        text: $summaryText,
                        placeholder: "No entries to summarize"
                    )
                    .frame(minHeight: 250)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                // Themes section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Key Themes (tap to edit):")
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(editingThemes ? "Done" : "Edit") {
                            editingThemes.toggle()
                        }
                        .font(.caption)
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    
                    if editingThemes {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(themes.indices, id: \.self) { index in
                                TextField("Theme \(index + 1)", text: $themes[index])
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            HStack {
                                Button("Add Theme") {
                                    themes.append("")
                                }
                                .disabled(themes.count >= 5)
                                
                                if themes.count > 0 {
                                    Button("Remove Last") {
                                        themes.removeLast()
                                    }
                                    .foregroundColor(.red)
                                }
                            }
                            .font(.caption)
                        }
                        .padding(.horizontal)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(themes.filter { !$0.isEmpty }, id: \.self) { theme in
                                HStack {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 6))
                                        .foregroundColor(.blue)
                                    Text(theme)
                                        .font(.body)
                                }
                                .padding(.leading, 8)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
                // Save button
                Button("Save Monthly Summary") {
                    saveSummary()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
                .disabled(summaryText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Monthly Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                setupInitialText()
            }
        }
    }
    
    private func setupInitialText() {
        if let existingReport = existingReport {
            summaryText = existingReport.summary
            themes = existingReport.themes
        } else {
            // Generate initial text from entries
            summaryText = generateInitialSummaryText()
            themes = ["Growth", "Relationships", "Self-reflection"] // Default themes
        }
    }
    
    private func generateInitialSummaryText() -> String {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.start ?? selectedMonth
        
        var text = "Journal entries for \(monthFormatter.string(from: selectedMonth)) (\(entries.count) entries):\n\n"
        
        for (index, entry) in entries.enumerated() {
            let dayFormatter = DateFormatter()
            dayFormatter.dateFormat = "MMM d"
            
            text += "\(dayFormatter.string(from: entry.date)): \(entry.displayText)\n\n"
        }
        
        return text
    }
    
    private func saveSummary() {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.start ?? selectedMonth
        
        let avgMoodScore = entries.compactMap(\.moodScore).reduce(0, +) / Double(max(1, entries.compactMap(\.moodScore).count))
        
        let report = MonthlyReport(
            month: startOfMonth,
            summary: summaryText,
            themes: themes.filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
            entryCount: entries.count,
            averageMoodScore: avgMoodScore
        )
        
        onSave(report)
        dismiss()
    }
}

#Preview {
    let sampleEntries = [
        JournalEntry(rawText: "Today was challenging but I learned a lot about resilience."),
        JournalEntry(rawText: "Grateful for my family's support during this difficult time."),
        JournalEntry(rawText: "Work stress is high, but I'm finding ways to cope better.")
    ]
    
    return MonthlySummaryPreviewView(
        entries: sampleEntries,
        selectedMonth: Date(),
        existingReport: nil
    ) { report in
        print("Saved report: \(report.summary)")
    }
}