//
//  TimelineView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI
import SwiftData

struct TimelineView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    
    @State private var showingNewEntry = false
    @State private var selectedEntry: JournalEntry?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(entries) { entry in
                    EntryRowView(entry: entry) {
                        selectedEntry = entry
                    }
                }
                .onDelete(perform: deleteEntries)
            }
            .navigationTitle("Bright Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingNewEntry = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewEntry) {
                EntryView()
            }
            .sheet(item: $selectedEntry) { entry in
                EntryView(entry: entry)
            }
        }
    }
    
    private func deleteEntries(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Error deleting entries: \(error)")
        }
    }
}

struct EntryRowView: View {
    let entry: JournalEntry
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(entry.date, format: .dateTime.day().month().year())
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    if let moodTag = entry.moodTag {
                        MoodChip(mood: moodTag, score: entry.moodScore)
                    }
                }
                
                Text(entry.displayText.prefix(100) + (entry.displayText.count > 100 ? "..." : ""))
                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                
                if entry.reframedText != nil {
                    HStack {
                        Image(systemName: "sparkles")
                            .foregroundColor(.blue)
                        Text("Reframed")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct MoodChip: View {
    let mood: String
    let score: Double?
    
    var moodColor: Color {
        switch mood {
        case "positive":
            return .green
        case "negative":
            return .red
        default:
            return .gray
        }
    }
    
    var moodIcon: String {
        switch mood {
        case "positive":
            return "face.smiling"
        case "negative":
            return "face.dashed"
        default:
            return "minus"
        }
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: moodIcon)
                .font(.caption2)
            Text(mood.capitalized)
                .font(.caption2)
                .fontWeight(.medium)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(moodColor.opacity(0.2))
        .foregroundColor(moodColor)
        .cornerRadius(12)
    }
}

#Preview {
    TimelineView()
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self], inMemory: true)
}