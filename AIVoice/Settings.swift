//
//  Settings.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import Foundation

class SettingsClass: ObservableObject {
    @Published var apiKey: String {
        didSet {
            UserDefaults.standard.set(apiKey, forKey: "APIKEY")
        }
    }
    
    init(apiKey: String) {
        self.apiKey = UserDefaults.standard.object(forKey: "APIKEY") as? String ?? ""
    }
}
