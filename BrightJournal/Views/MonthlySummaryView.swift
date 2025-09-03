//
//  MonthlySummaryView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI
import SwiftData

struct MonthlySummaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [JournalEntry]
    @Query private var reports: [MonthlyReport]
    
    @State private var selectedMonth = Date()
    @State private var showingSummaryPreview = false
    @State private var currentReport: MonthlyReport?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                // Month selector
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Month")
                        .font(.headline)
                    
                    DatePicker("Month", selection: $selectedMonth, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .onChange(of: selectedMonth) { _, newValue in
                            loadReportForMonth(newValue)
                        }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                // Generate report button
                if AIAvailability.isAvailable {
                    Button(action: {
                        showingSummaryPreview = true
                    }) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Generate Monthly Summary")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(entriesForSelectedMonth.isEmpty)
                } else {
                    VStack(spacing: 8) {
                        Text("Monthly Summary")
                            .font(.headline)
                        Text(AIAvailability.unavailableMessage)
                            .font(.caption)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Report display
                if let report = currentReport {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Report header
                            VStack(alignment: .leading, spacing: 8) {
                                Text(report.monthYearString)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                HStack {
                                    Text("\(report.entryCount) entries")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    
                                    if let avgMood = report.averageMoodScore {
                                        Spacer()
                                        Text("Avg mood: \(avgMood, specifier: "%.1f")")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            
                            // Summary
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Summary")
                                        .font(.headline)
                                    
                                    Spacer()
                                    
                                    Button("Edit") {
                                        showingSummaryPreview = true
                                    }
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                }
                                
                                Text(report.summary)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            
                            // Themes
                            if !report.themes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Key Themes")
                                        .font(.headline)
                                    
                                    ForEach(report.themes, id: \.self) { theme in
                                        HStack {
                                            Image(systemName: "circle.fill")
                                                .font(.system(size: 6))
                                                .foregroundColor(.blue)
                                            Text(theme)
                                        }
                                        .padding(.leading, 8)
                                    }
                                }
                            }
                            
                            // Export buttons
                            VStack(spacing: 12) {
                                // Share button
                                ShareLink(
                                    item: generateShareText(report: report),
                                    subject: Text("My Journal Summary for \(report.monthYearString)"),
                                    message: Text("Here's my monthly reflection from Bright Journal")
                                ) {
                                    HStack {
                                        Image(systemName: "square.and.arrow.up")
                                        Text("Share Summary")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                }
                                
                                // PDF Export button
                                Button(action: exportPDF) {
                                    HStack {
                                        Image(systemName: "doc.richtext")
                                        Text("Export as PDF")
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(.systemGray5))
                                    .foregroundColor(.primary)
                                    .cornerRadius(10)
                                }
                            }
                        }
                        .padding()
                    }
                } else if !entriesForSelectedMonth.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No summary generated yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if AIAvailability.isAvailable {
                            Text("Tap 'Generate Monthly Summary' to create an AI-powered recap of your entries")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        
                        Text("No entries for this month")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Start journaling to generate monthly summaries")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Monthly Summary")
            .onAppear {
                loadReportForMonth(selectedMonth)
            }
            .sheet(isPresented: $showingSummaryPreview) {
                MonthlySummaryPreviewView(
                    entries: entriesForSelectedMonth,
                    selectedMonth: selectedMonth,
                    existingReport: currentReport
                ) { report in
                    modelContext.insert(report)
                    do {
                        try modelContext.save()
                        currentReport = report
                    } catch {
                        print("Error saving monthly report: \(error)")
                    }
                }
            }
        }
    }
    
    private var entriesForSelectedMonth: [JournalEntry] {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.start ?? selectedMonth
        let endOfMonth = calendar.dateInterval(of: .month, for: selectedMonth)?.end ?? selectedMonth
        
        return entries.filter { entry in
            entry.date >= startOfMonth && entry.date < endOfMonth
        }
    }
    
    private func loadReportForMonth(_ date: Date) {
        let calendar = Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: date)?.start ?? date
        
        currentReport = reports.first { report in
            calendar.isDate(report.month, equalTo: startOfMonth, toGranularity: .month)
        }
    }
    
    private func generateShareText(report: MonthlyReport) -> String {
        var text = "My Journal Summary for \(report.monthYearString)\n\n"
        text += "\(report.summary)\n\n"
        text += "Key themes:\n"
        for theme in report.themes {
            text += "• \(theme)\n"
        }
        text += "\nGenerated with Bright Journal - AI-powered personal reflection"
        return text
    }
    
    private func exportPDF() {
        guard let report = currentReport else { return }
        
        let text = generateShareText(report: report)
        let title = "Monthly Summary – \(report.monthYearString)"
        
        if let url = PDFExporter.makeMonthlySummaryPDF(title: title, body: text) {
            // Present share sheet
            let activityViewController = UIActivityViewController(
                activityItems: [url],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                
                // For iPad compatibility
                if let popover = activityViewController.popoverPresentationController {
                    popover.sourceView = rootViewController.view
                    popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX, y: rootViewController.view.bounds.midY, width: 0, height: 0)
                    popover.permittedArrowDirections = []
                }
                
                rootViewController.present(activityViewController, animated: true)
            }
        }
    }
}

#Preview {
    MonthlySummaryView()
        .modelContainer(for: [JournalEntry.self, MonthlyReport.self], inMemory: true)
}