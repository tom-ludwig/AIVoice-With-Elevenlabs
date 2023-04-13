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
    @State private var showAPIAlert: Bool = false
    @State private var showConformation: Bool = false
    @State private var apiKey: String = ""
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
                .onAppear {
                    if settings.apiKey.isEmpty {
                        self.showAPIAlert = true
                    }
                }
                .alert("Set API-Key", isPresented: $showAPIAlert) {
                    Button("Cancel", role: .cancel) {
                        
                    }
                    Button("Save") {
                        settings.apiKey = apiKey
                        self.showAPIAlert = false
                        self.showConformation = true
                    }
                    TextField("Your api-key", text: $apiKey)
                } message: {
                    Text("A API key is needed to communicate with the elevenlabs servers.")
                }
                .alert("Thank you", isPresented: $showConformation) {
                    Button("Done", role: .cancel) {}
                } message: {
                    Text("Important: Please restart the application manually!")
                }

        }
    }
}
