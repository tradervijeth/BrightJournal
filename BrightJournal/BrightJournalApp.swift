//
//  BrightJournalApp.swift
//  BrightJournal
//
//  Created by Vithushan Jeyapahan on 03/09/2025.
//

import SwiftUI

@main
struct BrightJournalApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
