//
//  LifehacksApp.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import SwiftUI

@main
struct LifehacksApp: App {
    @StateObject private var stateController = StateController()
    @StateObject private var settingsController = SettingsController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(stateController)
                .environmentObject(settingsController)
        }
    }
}

extension LifehacksApp {
    struct Keys {
        static let themeName = "ThemeName"
        static let isLoggedIn = "IsLoggedIn"
    }
}
