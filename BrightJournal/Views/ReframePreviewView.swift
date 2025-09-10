//
//  ReframePreviewView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

struct ReframePreviewView: View {
    @Environment(\.dismiss) private var dismiss
    
    let originalText: String
    @State private var workingText: String
    let onSave: (String) -> Void
    
    init(originalText: String, currentReframedText: String, onSave: @escaping (String) -> Void) {
        self.originalText = originalText
        self._workingText = State(initialValue: currentReframedText.isEmpty ? originalText : currentReframedText)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Instructions
                VStack(alignment: .leading, spacing: 12) {
                    Text("Manual Text Editing")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Edit your text manually or use Writing Tools by selecting text and tapping ••• in the context menu.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 8)
                    
                    if AIAvailability.isAvailable {
                        HStack {
                            Image(systemName: "sparkles")
                                .foregroundColor(.blue)
                            Text("Select text, then tap ••• for Writing Tools (Rewrite, Summarize, Proofread)")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 8)
                    } else {
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
                
                // Editable text view with Writing Tools
                VStack(alignment: .leading, spacing: 8) {
                    Text("Edit your text:")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    WritingToolsTextView(
                        text: $workingText,
                        placeholder: "No text to edit"
                    )
                    .frame(minHeight: 300)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.systemGray4), lineWidth: 1)
                    )
                    .padding(.horizontal)
                }
                
                // Action buttons
                HStack(spacing: 16) {
                    Button("Reset to Original") {
                        workingText = originalText
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    
                    Button("Use This Text") {
                        onSave(workingText)
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(workingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
            .navigationTitle("Manual Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ReframePreviewView(
        originalText: "Today was really challenging and I made several mistakes at work. I'm feeling overwhelmed and everything seems to be going wrong.",
        currentReframedText: ""
    ) { newText in
        print("Edited text: \(newText)")
    }
}