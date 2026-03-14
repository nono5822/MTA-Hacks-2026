//
//  SealSenseiApp.swift
//  Studious Seal
//
//  Remote control and dashboard for OpenClaw AI study agent. iOS 17+.
//

import SwiftUI
import UIKit

@main
struct SealSenseiApp: App {
    init() {
        let darkBlue = UIColor(red: 0.141, green: 0.604, blue: 0.851, alpha: 1)
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithOpaqueBackground()
        navAppearance.backgroundColor = darkBlue
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().tintColor = .white

        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = darkBlue
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        UITabBar.appearance().tintColor = UIColor(red: 0.890, green: 0.655, blue: 0.220, alpha: 1) // gold
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
