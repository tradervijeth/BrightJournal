//
//  JournalEntryEditor.swift
//  BrightJournal
//

import SwiftUI

struct JournalEntryEditor: View {
    @Binding var entry: JournalEntry
    
    var body: some View {
        TextEditor(text: $entry.rawText)
            .writingToolsBehavior(.complete)  // Enable full Apple Writing Tools
            .font(.body)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
    }
}

#Preview {
    JournalEntryEditor(entry: .constant(JournalEntry.sampleEntry))
}