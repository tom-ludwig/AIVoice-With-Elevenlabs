//
//  AIVoiceApp.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 11.04.23.
//
//

import SwiftUI

@main
struct AIVoiceApp: App {
    @ObservedObject var settings = SettingsClass(apiKey: "")
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
    }
}
