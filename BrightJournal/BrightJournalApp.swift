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
            AppleIntelligenceGateView()
        }
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self])
    }
}

/// Gate view that ensures Apple Intelligence is available before showing the main app
struct AppleIntelligenceGateView: View {
    var body: some View {
        if AIAvailability.isAvailable {
            ContentView()
        } else {
            AppleIntelligenceRequiredView()
        }
    }
}

/// Premium Apple Intelligence requirement screen
struct AppleIntelligenceRequiredView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Icon/Logo area
            Image(systemName: "brain.head.profile.fill")
                .font(.system(size: 80))
                .foregroundStyle(.linearGradient(
                    colors: [.purple, .blue, .cyan],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            
            VStack(spacing: 16) {
                Text("BrightJournal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("AI-Powered Positive Psychology")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            
            VStack(spacing: 20) {
                Text("Apple Intelligence Required")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("BrightJournal uses advanced on-device AI to provide professional-quality cognitive behavioral therapy techniques for reframing negative thoughts.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                
                // Status message
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundStyle(.orange)
                    Text(AIAvailability.statusMessage)
                        .fontWeight(.medium)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
            
            VStack(spacing: 16) {
                Text("Requirements:")
                    .font(.headline)
                
                VStack(alignment: .leading, spacing: 8) {
                    RequirementRow(
                        icon: "iphone.gen3",
                        text: "iPhone 15 Pro or newer",
                        isMet: true
                    )
                    RequirementRow(
                        icon: "gear",
                        text: "iOS 26.0 or later",
                        isMet: true
                    )
                    RequirementRow(
                        icon: "brain.head.profile",
                        text: "Apple Intelligence enabled",
                        isMet: AIAvailability.isAvailable
                    )
                }
            }
            
            if !AIAvailability.isAvailable {
                Button {
                    if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(settingsUrl)
                    }
                } label: {
                    Text("Open Settings")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color(.systemBackground))
    }
}

/// Requirement row component
struct RequirementRow: View {
    let icon: String
    let text: String
    let isMet: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundStyle(isMet ? .green : .secondary)
            
            Text(text)
                .foregroundStyle(isMet ? .primary : .secondary)
            
            Spacer()
            
            Image(systemName: isMet ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundStyle(isMet ? .green : .red)
        }
    }
}

#Preview("Available") {
    AppleIntelligenceGateView()
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self], inMemory: true)
}

#Preview("Required") {
    AppleIntelligenceRequiredView()
}