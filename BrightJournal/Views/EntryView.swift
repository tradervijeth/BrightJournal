//
//  EntryView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI
import SwiftData

struct EntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var rawText: String = ""
    @State private var reframedText: String = ""
    @State private var useReframedVersion: Bool = false
    @State private var isGeneratingReframe = false
    @State private var reframeError: String?
    @State private var showTextDiff = false
    
    @StateObject private var aiService = AIReframingService()
    
    let entry: JournalEntry?
    
    init(entry: JournalEntry? = nil) {
        self.entry = entry
        if let entry = entry {
            _rawText = State(initialValue: entry.rawText)
            _reframedText = State(initialValue: entry.reframedText ?? "")
            _useReframedVersion = State(initialValue: entry.reframedText != nil)
        }
    }
    
    var hasEnoughText: Bool {
        rawText.trimmingCharacters(in: .whitespacesAndNewlines).count >= 10
    }
    
    var finalText: String {
        useReframedVersion && !reframedText.isEmpty ? reframedText : rawText
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    textInputSection
                    
                    if AIAvailability.isAvailable {
                        aiReframingSection
                    } else {
                        aiUnavailableSection
                    }
                    
                    if showTextDiff && !reframedText.isEmpty {
                        textComparisonSection
                    }
                }
                .padding()
            }
            .navigationTitle(entry == nil ? "New Entry" : "Edit Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
    
    private var textInputSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your thoughts:")
                .font(.headline)
                .foregroundColor(.primary)
            
            WritingToolsTextView(
                text: $rawText,
                placeholder: "Write about your day, thoughts, or feelings..."
            )
            .frame(minHeight: 120)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .onChange(of: rawText) { _, _ in
                // Clear previous reframe when text changes significantly
                if !reframedText.isEmpty && rawText.count < Int(Double(reframedText.count) * 0.8) {
                    reframedText = ""
                    useReframedVersion = false
                }
            }
        }
    }
    
    private var aiReframingSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // AI Section Header
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                Text("AI-Powered Positive Reframe")
                    .font(.headline)
                    .foregroundColor(.blue)
                Spacer()
            }
            
            if hasEnoughText {
                if reframedText.isEmpty {
                    generateReframeButton
                } else {
                    reframedTextPreview
                }
                
                if let error = reframeError {
                    errorMessage(error)
                }
            } else {
                insufficientTextMessage
            }
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(16)
    }
    
    private var generateReframeButton: some View {
        Button(action: generateReframe) {
            HStack {
                if isGeneratingReframe {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Reframing your thoughts...")
                } else {
                    Image(systemName: "wand.and.stars")
                    Text("Generate Positive Reframe")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isGeneratingReframe ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(isGeneratingReframe)
    }
    
    private var reframedTextPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("✨ Positive Reframe:")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                
                Spacer()
                
                Button("Compare") {
                    showTextDiff.toggle()
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            Text(reframedText)
                .padding(12)
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                )
            
            versionSelectionButtons
            
            Button("Generate New Reframe") {
                generateReframe()
            }
            .font(.caption)
            .foregroundColor(.blue)
            .padding(.top, 4)
        }
    }
    
    private var versionSelectionButtons: some View {
        VStack(spacing: 8) {
            Text("Which version would you like to save?")
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack(spacing: 12) {
                Button(action: { useReframedVersion = false }) {
                    HStack {
                        Image(systemName: useReframedVersion ? "circle" : "checkmark.circle.fill")
                        Text("Original")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(useReframedVersion ? Color.clear : Color.blue.opacity(0.1))
                    .foregroundColor(useReframedVersion ? .secondary : .blue)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(useReframedVersion ? Color.gray : Color.blue, lineWidth: 1)
                    )
                }
                
                Button(action: { useReframedVersion = true }) {
                    HStack {
                        Image(systemName: useReframedVersion ? "checkmark.circle.fill" : "circle")
                        Text("Reframed")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(useReframedVersion ? Color.green.opacity(0.1) : Color.clear)
                    .foregroundColor(useReframedVersion ? .green : .secondary)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(useReframedVersion ? Color.green : Color.gray, lineWidth: 1)
                    )
                }
            }
        }
    }
    
    private var aiUnavailableSection: some View {
        VStack {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.orange)
                Text(AIAvailability.statusMessage)
                    .font(.caption)
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color.orange.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var insufficientTextMessage: some View {
        Text("Write at least 10 characters to get AI suggestions")
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
    
    private func errorMessage(_ error: String) -> some View {
        Text(error)
            .font(.caption)
            .foregroundColor(.red)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
    }
    
    private var textComparisonSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Text Comparison")
                .font(.headline)
            
            TextDiffView(original: rawText, reframed: reframedText)
        }
        .padding(16)
        .background(Color(.systemGray6).opacity(0.3))
        .cornerRadius(12)
    }
    
    private func generateReframe() {
        reframeError = nil
        isGeneratingReframe = true
        
        Task {
            do {
                let result = try await aiService.reframeText(rawText)
                await MainActor.run {
                    reframedText = result
                    isGeneratingReframe = false
                }
            } catch {
                await MainActor.run {
                    reframeError = error.localizedDescription
                    isGeneratingReframe = false
                }
            }
        }
    }
    
    private func saveEntry() {
        let textToSave = finalText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !textToSave.isEmpty else { return }
        
        if let existingEntry = entry {
            // Update existing entry
            existingEntry.rawText = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
            if useReframedVersion && !reframedText.isEmpty {
                existingEntry.reframedText = reframedText
            } else {
                existingEntry.reframedText = nil
            }
            existingEntry.analyzeMood()
        } else {
            // Create new entry
            let newEntry = JournalEntry(rawText: rawText.trimmingCharacters(in: .whitespacesAndNewlines))
            if useReframedVersion && !reframedText.isEmpty {
                newEntry.reframedText = reframedText
            }
            newEntry.analyzeMood()
            modelContext.insert(newEntry)
        }
        
        do {
            try modelContext.save()
            dismiss()
        } catch {
            print("Error saving entry: \(error)")
        }
    }
}

#Preview {
    EntryView()
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self], inMemory: true)
}