//
//  StudyVaultView.swift
//  Studious Seal
//
//  Tab 3: Knowledge gaps list; tap for detail (question, wrong/correct, links).
//

import SwiftUI

struct StudyVaultView: View {
    @ObservedObject var api: APIService

    private var gaps: [KnowledgeGap] { api.dashboard?.knowledgeGaps ?? [] }

    var body: some View {
        NavigationStack {
            Group {
                if api.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if api.dashboard == nil, api.error == nil {
                    ContentUnavailableView("No data", systemImage: "book.closed", description: Text("Knowledge gaps will appear here."))
                } else {
                    List(gaps) { gap in
                        NavigationLink(value: gap) {
                            KnowledgeGapRow(gap: gap)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .refreshable { await api.fetchDashboard() }
                }
            }
            .navigationTitle("Study Vault")
            .navigationDestination(for: KnowledgeGap.self) { gap in
                KnowledgeGapDetailView(gap: gap)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mock") { api.loadMockData() }
                }
            }
        }
    }
}

struct KnowledgeGapRow: View {
    let gap: KnowledgeGap

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(gap.topic)
                .font(.headline)
            Text(gap.questionAsked)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            if let status = gap.status {
                Text(status)
                    .font(.caption)
                    .foregroundStyle(.orange)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    StudyVaultView(api: {
        let s = APIService()
        s.loadMockData()
        return s
    }())
}
