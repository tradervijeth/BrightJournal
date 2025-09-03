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
    @State private var showReframedText = false
    @State private var reframedText: String = ""
    @State private var showingReframePreview = false
    
    let entry: JournalEntry?
    
    init(entry: JournalEntry? = nil) {
        self.entry = entry
        if let entry = entry {
            _rawText = State(initialValue: entry.rawText)
            _reframedText = State(initialValue: entry.reframedText ?? "")
            _showReframedText = State(initialValue: entry.reframedText != nil)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Original text editor with Writing Tools
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your thoughts:")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    WritingToolsTextView(
                        text: $rawText,
                        placeholder: "Write about your day, thoughts, or feelings..."
                    )
                    .frame(minHeight: 200)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    
                    // Writing Tools hint
                    if AIAvailability.isAvailable {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.blue)
                                .font(.caption)
                            Text("Select text, then tap ••• to access Writing Tools (Rewrite, Summarize, Proofread)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal, 4)
                    } else {
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(.orange)
                                .font(.caption)
                            Text(AIAvailability.unavailableMessage)
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 4)
                    }
                }
                
                // Preview Reframe button (only show if AI is available and text exists)
                if AIAvailability.isAvailable && !rawText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    Button(action: {
                        showingReframePreview = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.right.circle")
                            Text("Preview Reframe")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                
                // Reframed text display with diff view
                if showReframedText && !reframedText.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Text Comparison:")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button("Edit") {
                                showingReframePreview = true
                            }
                            .font(.caption)
                            .foregroundColor(.blue)
                        }
                        
                        TextDiffView(original: rawText, reframed: reframedText)
                    }
                }
                
                Spacer()
            }
            .padding()
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
                }
            }
            .sheet(isPresented: $showingReframePreview) {
                ReframePreviewView(
                    originalText: rawText,
                    currentReframedText: reframedText
                ) { newReframedText in
                    reframedText = newReframedText
                    showReframedText = !newReframedText.isEmpty
                }
            }
        }
    }
    
    private func saveEntry() {
        let trimmedText = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        if let existingEntry = entry {
            // Update existing entry
            existingEntry.rawText = trimmedText
            if !reframedText.isEmpty {
                existingEntry.reframedText = reframedText
            }
            existingEntry.analyzeMood()
        } else {
            // Create new entry
            let newEntry = JournalEntry(rawText: trimmedText)
            if !reframedText.isEmpty {
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