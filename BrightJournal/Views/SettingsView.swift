//
//  SettingsView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

struct SettingsView: View {
    @State private var showingPrivacyPolicy = false
    @State private var showingTerms = false
    @State private var showingAbout = false
    
    var body: some View {
        NavigationStack {
            List {
                Section("Privacy & Data") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("🔒 Your data stays on your device")
                            .font(.headline)
                        Text("Bright Journal uses Apple Intelligence for on-device processing. Your entries never leave your device.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Apple Intelligence Features") {
                    FeatureRow(
                        icon: "pencil.and.sparkles",
                        title: "Writing Tools",
                        description: "Reframe your thoughts with positive AI assistance"
                    )
                    
                    FeatureRow(
                        icon: "chart.bar.doc.horizontal",
                        title: "Smart Summaries",
                        description: "Generate monthly insights from your entries"
                    )
                    
                    FeatureRow(
                        icon: "face.smiling",
                        title: "Mood Analysis",
                        description: "On-device sentiment detection for self-awareness"
                    )
                }
                
                Section("Legal") {
                    Button("Privacy Policy") {
                        showingPrivacyPolicy = true
                    }
                    
                    Button("Terms of Service") {
                        showingTerms = true
                    }
                    
                    Button("About Bright Journal") {
                        showingAbout = true
                    }
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("⚠️ Not Medical Advice")
                            .font(.headline)
                            .foregroundColor(.orange)
                        Text("This app is for personal reflection only and is not intended to diagnose, treat, or replace professional mental health care.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Settings")
        }
        .sheet(isPresented: $showingPrivacyPolicy) {
            PrivacyPolicyView()
        }
        .sheet(isPresented: $showingTerms) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Privacy Policy")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last updated: \(Date().formatted(date: .complete, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Group {
                        SectionView(title: "Data Collection", content: "Bright Journal does not collect, store, or transmit any personal data to external servers. All your journal entries remain on your device.")
                        
                        SectionView(title: "Apple Intelligence", content: "We use Apple's on-device AI features including Writing Tools for text enhancement and summarization. Apple Intelligence processing happens on your device or through Private Cloud Compute with strong privacy protections.")
                        
                        SectionView(title: "Local Storage", content: "Your entries are stored locally using SwiftData and may sync with your other devices via iCloud if enabled in your device settings.")
                        
                        SectionView(title: "No Tracking", content: "We do not use any analytics, advertising, or user tracking technologies.")
                        
                        SectionView(title: "Contact", content: "For privacy questions, please contact us through the App Store.")
                    }
                }
                .padding()
            }
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Service")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last updated: \(Date().formatted(date: .complete, time: .omitted))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Group {
                        SectionView(title: "Acceptable Use", content: "Bright Journal is intended for personal reflection and journaling. Users must not use the app for any abusive, harmful, or illegal content.")
                        
                        SectionView(title: "Not Medical Advice", content: "This app provides tools for personal reflection and is not intended to diagnose, treat, cure, or prevent any medical condition. Always consult healthcare professionals for medical advice.")
                        
                        SectionView(title: "AI Content", content: "AI-generated suggestions are for reflection purposes only. Users are responsible for their own content and decisions.")
                        
                        SectionView(title: "Age Requirement", content: "Users must be 13 years or older to use this app. Users under 18 should have parental consent.")
                        
                        SectionView(title: "Liability", content: "The app is provided 'as is' without warranties. We are not liable for any damages from use of the app.")
                    }
                }
                .padding()
            }
            .navigationTitle("Terms")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // App icon placeholder
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay {
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 50))
                                .foregroundColor(.white)
                        }
                    
                    VStack(spacing: 8) {
                        Text("Bright Journal")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("AI-Powered Personal Reflection")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("Version 1.0")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Transform your thoughts into positive reflections using Apple Intelligence. Bright Journal helps you reframe challenging experiences, track your emotional journey, and gain insights through AI-powered monthly summaries.")
                            .multilineTextAlignment(.center)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Features:")
                                .font(.headline)
                            
                            FeatureRow(icon: "sparkles", title: "AI Reframing", description: "Turn negative thoughts into growth opportunities")
                            FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Mood Tracking", description: "Understand your emotional patterns")
                            FeatureRow(icon: "doc.text", title: "Monthly Summaries", description: "AI-generated insights from your entries")
                            FeatureRow(icon: "lock.shield", title: "Complete Privacy", description: "Everything stays on your device")
                        }
                    }
                    
                    Text("Requires iOS 18.1+ and Apple Intelligence-capable device")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SectionView: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(content)
                .font(.body)
        }
    }
}

#Preview {
    SettingsView()
}