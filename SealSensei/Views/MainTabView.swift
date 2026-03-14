//
//  MainTabView.swift
//  Seal Sensei
//
//  3-tab app: Focus Dashboard, Intervention Feed, Study Vault.
//

import SwiftUI

struct MainTabView: View {
    @StateObject private var api = APIService()

    var body: some View {
        TabView {
            FocusDashboardView(api: api)
                .tabItem {
                    Label("Focus", systemImage: "gauge.with.dots.needle.67percent")
                }
            InterventionFeedView(api: api)
                .tabItem {
                    Label("Interventions", systemImage: "bubble.left.and.bubble.right")
                }
            StudyVaultView(api: api)
                .tabItem {
                    Label("Study Vault", systemImage: "book.closed")
                }
        }
        .task {
            await api.fetchDashboard()
        }
    }
}

#Preview {
    MainTabView()
}
