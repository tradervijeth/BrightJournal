//
//  BrightJournalApp.swift
//  BrightJournal
//
//  Created by Vithushan Jeyapahan on 03/09/2025.
//

import SwiftUI
import SwiftData

@main
struct BrightJournalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self])
    }
}