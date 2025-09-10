//
//  WritingToolsTextView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI
import UIKit

struct WritingToolsTextView: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let font: UIFont
    
    init(text: Binding<String>, placeholder: String = "", font: UIFont = .preferredFont(forTextStyle: .body)) {
        self._text = text
        self.placeholder = placeholder
        self.font = font
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = font
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.isSelectable = true
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.textColor = .label
        
        // Enable Writing Tools in iOS 18.1+
        if #available(iOS 18.1, *) {
            textView.writingToolsBehavior = .default
            textView.isSelectable = true
        } else if #available(iOS 18.0, *) {
            textView.isSelectable = true
        }
        
        // Add placeholder behavior
        if text.isEmpty && !placeholder.isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        } else {
            textView.text = text
            textView.textColor = .label
        }
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Only update if the text actually changed to avoid cursor jumping
        if uiView.text != text {
            if text.isEmpty && !placeholder.isEmpty {
                uiView.text = placeholder
                uiView.textColor = .placeholderText
            } else {
                uiView.text = text
                uiView.textColor = .label
            }
        }
        
        // Ensure Writing Tools behavior is maintained
        if #available(iOS 18.1, *) {
            uiView.writingToolsBehavior = .default
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: WritingToolsTextView
        
        init(_ parent: WritingToolsTextView) {
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            // Clear placeholder when user starts editing
            if textView.text == parent.placeholder {
                textView.text = ""
                textView.textColor = .label
            }
            
            // Ensure Writing Tools are available when editing begins
            if #available(iOS 18.1, *) {
                textView.writingToolsBehavior = .default
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Update the binding
            if textView.textColor != .placeholderText {
                parent.text = textView.text
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            // Restore placeholder if text is empty
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
                parent.text = ""
            }
        }
    }
}

#Preview {
    @State var sampleText = "This is sample text that can be enhanced with Writing Tools."
    
    VStack {
        Text("Writing Tools Text View")
            .font(.headline)
            .padding()
        
        WritingToolsTextView(
            text: $sampleText,
            placeholder: "Enter your thoughts here..."
        )
        .frame(height: 200)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding()
        
        if AIAvailability.isAvailable {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.blue)
                Text("Select text, then tap ••• to access Writing Tools")
            }
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        } else {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.orange)
                Text(AIAvailability.statusMessage)
            }
            .font(.caption)
            .foregroundColor(.orange)
            .multilineTextAlignment(.center)
            .padding(.horizontal)
        }
        
        Spacer()
    }
}