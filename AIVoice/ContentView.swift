//
//  ContentView.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 11.04.23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var voices: Welcome? = nil
    @State var audioData: Data? = nil
    @State var audioPlayer: AVAudioPlayer?
    @State var text: String = ""
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(voices?.voices ?? Array(), id: \.id) { voice in
                        Button {
                            Task {
                                await convertToAudio(text: text, voice: voice.voiceID ?? "21m00Tcm4TlvDq8ikWAM")
                            }
                        } label: {
                            HStack {
                                Text("\(voice.name ?? "No name given")")
                                Spacer()
                                Text("\(voice.voiceID ?? "No ID given")")
                                    .font(.subheadline)
                            }
                            .fontDesign(.monospaced)
                        }
                    }
                }
                
                HStack {
                    TextField("Insert text", text: $text)
                        .textFieldStyle(.roundedBorder)
                        .fontDesign(.monospaced)
                    
                    Button {
                        Task {
                            await convertToAudio(text: text, voice: "21m00Tcm4TlvDq8ikWAM")
                        }
                    } label: {
                        Image(systemName: "paperplane")
                    }.buttonStyle(.bordered).tint(.blue)
                }.padding()
                
                if audioData != nil {
                   Text("GOT AUDIO FILE")
                        .fontDesign(.monospaced)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("AI-Voices")
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            await getVoices()
                        }
                    } label: {
                        Text("GET")
                            .fontDesign(.monospaced)
                    }
                    .buttonStyle(.bordered)
                    .tint(.blue)
                }
                
//                ToolbarItem {
//                    Button {
//                        Task {
//                            await convertToAudio()
//                        }
//                    } label: {
//                        Text("VOICE")
//                            .fontDesign(.monospaced)
//                    }
//                    .buttonStyle(.bordered)
//                    .tint(.blue)
//                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        do {
                            if let audioData = audioData {
                                audioPlayer = try AVAudioPlayer(data: audioData)
                                audioPlayer?.prepareToPlay()
                                print(audioPlayer?.isPlaying ?? false)
                            } else {
                                print("Audiodata == nil")
                            }
                        } catch {
                            print("Erorr loading audio data: \(error.localizedDescription)")
                        }
                    } label: {
                        Text("PLAY")
                            .fontDesign(.monospaced)
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        audioPlayer?.pause()
                    } label: {
                        Image(systemName: "pause")
                            .fontDesign(.monospaced)
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        audioPlayer?.play()
                    } label: {
                        Image(systemName: "play")
                            .fontDesign(.monospaced)
                    }
                    .buttonStyle(.bordered)
                    .tint(.indigo)
                }
            }
        }
    }
    
    func getVoices() async {
        let url = URL(string: "https://api.elevenlabs.io/v1/voices")!
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "83572ac07e9d1f4e9d53574e17ba2906")
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
                self.voices = result
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
        guard let header = "83572ac07e9d1f4e9d53574e17ba2906".data(using: .utf8) else {
            print("Invalid header")
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
        urlRequest.addValue("audio/mpeg", forHTTPHeaderField: "Accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("83572ac07e9d1f4e9d53574e17ba2906", forHTTPHeaderField: "xi-api-key")
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
            audioData = data
        }.resume()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(audioPlayer: AVAudioPlayer(data: nil))
//    }
//}
