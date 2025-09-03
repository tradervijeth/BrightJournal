//
//  TextDiffView.swift
//  BrightJournal
//
//  Created by AI Assistant on 03/09/2025.
//

import SwiftUI

struct TextDiffView: View {
    let original: String
    let reframed: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.secondary)
                    Text("Original")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                
                ScrollView {
                    Text(original)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                }
                .frame(minHeight: 120, maxHeight: 150)
            }

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundColor(.green)
                    Text("Reframed")
                        .font(.headline)
                        .foregroundColor(.green)
                }
                
                ScrollView {
                    Text(reframed)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.green.opacity(0.12))
                        .cornerRadius(8)
                }
                .frame(minHeight: 120, maxHeight: 150)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    TextDiffView(
        original: "Today was really challenging and I made several mistakes at work. Everything seems to be going wrong and I'm feeling overwhelmed by all the stress.",
        reframed: "Today presented some learning opportunities at work, and while I faced some challenges, each mistake is a chance to grow. I'm building resilience through these experiences and developing better coping strategies for managing stress."
    )
    .padding()
}