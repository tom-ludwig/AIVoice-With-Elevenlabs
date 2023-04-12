//
//  SettingsView.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: SettingsClass
    @State private var apikey: String = ""
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Current API-KEY: ")
                    Text(settings.apiKey)
                        .font(.system(size: 20, weight: .medium, design: .monospaced))
                        .foregroundColor(.secondary)
                }
                TextField("API-Key", text: $apikey)
                    .textFieldStyle(.roundedBorder)
                HStack {
                    Text("**IMPORTNAT:**")
                    Text("Please restart the application after saving the api-key.")
                }
                .fontDesign(.monospaced)
                .font(.caption2)
                
                Button {
                    self.settings.apiKey = apikey
                } label: {
                    Text("Save")
                        .fontDesign(.monospaced)
                }.buttonStyle(.bordered).tint(.indigo)
            }
            .padding()
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
