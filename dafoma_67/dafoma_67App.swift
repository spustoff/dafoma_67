//
//  LinguaLearnJugaApp.swift
//  LinguaLearnJuga
//
//  Created by Вячеслав on 10/13/25.
//

import SwiftUI

@main
struct LinguaLearnJugaApp: App {
    @StateObject private var dataService = DataService.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataService)
                .preferredColorScheme(UserDefaults.standard.bool(forKey: "isDarkMode") ? .dark : .light)
        }
    }
}
