//
//  FocusDashboardView.swift
//  Seal Sensei
//
//  Tab 1: Urgency meter, live status card, upcoming assignments.
//

import SwiftUI

struct FocusDashboardView: View {
    @ObservedObject var api: APIService

    private var liveStatus: LiveStatus? { api.dashboard?.liveStatus }
    private var assignments: [Assignment] {
        let list = api.dashboard?.assignments ?? []
        return list.sorted { a, b in
            (a.dueDateParsed ?? .distantFuture) < (b.dueDateParsed ?? .distantFuture)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if api.isLoading {
                    ProgressView("Loading…")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let err = api.error {
                    ContentUnavailableView("Couldn't load dashboard", systemImage: "wifi.exclamationmark", description: Text(err.localizedDescription))
                } else if api.dashboard == nil {
                    ContentUnavailableView("No data", systemImage: "tray", description: Text("Pull to refresh or load mock data."))
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 24) {
                            if let status = liveStatus {
                                UrgencyMeter(score: status.overallUrgencyScore)
                                    .frame(maxWidth: .infinity)

                                LiveStatusCard(status: status)

                                sectionHeader("Upcoming Assignments")
                                ForEach(assignments) { assignment in
                                    AssignmentRow(assignment: assignment)
                                }
                            }
                        }
                        .padding()
                    }
                    .refreshable { await api.fetchDashboard() }
                }
            }
            .navigationTitle("Focus")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Mock") { api.loadMockData() }
                }
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(.secondary)
    }
}

// MARK: - Live Status Card

struct LiveStatusCard: View {
    let status: LiveStatus

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: status.isGaming ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.title2)
                .foregroundStyle(status.isGaming ? .orange : .green)

            VStack(alignment: .leading, spacing: 4) {
                Text(status.isGaming ? "Gaming detected" : "Focus mode")
                    .font(.headline)
                if status.isGaming, let activity = status.currentActivity, !activity.isEmpty {
                    Text(activity)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Assignment Row

struct AssignmentRow: View {
    let assignment: Assignment

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text(assignment.title)
                    .font(.subheadline.weight(.medium))
                Text(assignment.dueDateParsed?.formatted(date: .abbreviated, time: .shortened) ?? assignment.dueDate)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let score = assignment.priorityScore {
                Text("P\(score)")
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.orange.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Color(.tertiarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    FocusDashboardView(api: {
        let s = APIService()
        s.loadMockData()
        return s
    }())
}
