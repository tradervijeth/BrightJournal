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
        textView.delegate = context.coordinator
        textView.backgroundColor = .clear
        textView.textColor = .label
        
        // Enable Writing Tools in iOS 18+
        if #available(iOS 18.0, *) {
            textView.isSelectable = true
            // Writing Tools will appear automatically in the edit menu
        }
        
        // Add placeholder behavior
        if text.isEmpty && !placeholder.isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
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
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // Update the binding
            parent.text = textView.text
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
    
    return VStack {
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
            Text("💡 Select text, then tap ••• to access Writing Tools")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        } else {
            Text(AIAvailability.unavailableMessage)
                .font(.caption)
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        
        Spacer()
    }
}