//
//  Functions.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import Foundation
import SwiftUI

class Manager: ObservableObject {
    @Published var voices: Welcome? = nil
    @Published var audioData: Data? = nil
    @ObservedObject var settings = SettingsClass(apiKey: "")
    
    func getVoices() async {
        let url = URL(string: "https://api.elevenlabs.io/v1/voices")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "\(settings.apiKey)")
        urlRequest.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Welcome.self, from: data)
                DispatchQueue.main.async {
                    self.voices = result
                }
                print(result)
            } catch {
                print("Decodering error: \(error)")
                
                if let json = try? JSONSerialization.jsonObject(with: data, options: []),
                           let jsonData = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]),
                           let jsonString = String(data: jsonData, encoding: .utf8) {
                            print("JSON data: \(jsonString)")
                        }
                
            }
        } catch {
            print("URLSession failed!: \(error)")
        }
    }
    
    func convertToAudio(text: String, voice: String) async {
        // 21m00Tcm4TlvDq8ikWAM
        guard let url = URL(string: "https://api.elevenlabs.io/v1/text-to-speech/\(voice)") else {
            print("Invalid URL")
            return
        }
        let request: [String : Any] = [
            "text": "\(text)",
            "voice_settings": [
                "stability": 0,
                "similarity_boost": 0
            ]
        ]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: request, options: []) else {
            print("Error while converting to Data")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("audio/mp3", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("\(settings.apiKey)", forHTTPHeaderField: "xi-api-key")
        urlRequest.httpBody = httpBody
        print("Done!")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard data != nil else { return }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP RESPONSE: \(httpResponse.statusCode)")
                }
                return
            }
            
            print("Data is fine!")
            DispatchQueue.main.async {
                withAnimation() {
                    self.audioData = data
                }
            }
        }.resume()
    }
}
