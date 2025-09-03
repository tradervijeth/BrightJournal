//
//  ContentView.swift
//  BrightJournal
//
//  Created by Vithushan Jeyapahan on 03/09/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            TimelineView()
                .tabItem {
                    Image(systemName: "book.pages")
                    Text("Journal")
                }
            
            MonthlySummaryView()
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Summary")
                }
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self], inMemory: true)
}