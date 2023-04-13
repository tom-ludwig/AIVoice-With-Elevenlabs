//
//  ContentView.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 11.04.23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @EnvironmentObject var settings: SettingsClass
    @ObservedObject var manager = Manager()
    @State private var showSettings: Bool = false
    @State var text: String = ""
    @State var selectedVoiceID: String = "21m00Tcm4TlvDq8ikWAM"
    var body: some View {
        NavigationView {
            Form {
                Section {
                    if manager.audioData != nil {
                        AudioPlayer(data: manager.audioData)
                            .id(manager.audioData)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button {
                                    withAnimation() {
                                        self.manager.audioData = nil
                                    }
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.title)
                                }.tint(.red)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    // do something
                                } label: {
                                    Image(systemName: "square.and.arrow.down")
                                        .font(.title)
                                }.tint(.gray)
                            }
                    }
                }
                Section {
                    if let voices = manager.voices {
                        ListView(voices: voices.voices, selectedVoiceID: $selectedVoiceID)
                    } else {
                        ProgressView()
                    }
                }
                
                Section {
                    HStack {
                        TextField("Insert text", text: $text)
                            .textFieldStyle(.roundedBorder)
                            .fontDesign(.monospaced)
                        
                        Button {
                            Task {
                                await manager.convertToAudio(text: text, voice: selectedVoiceID)
                            }
                        } label: {
                            Image(systemName: "paperplane")
                        }.buttonStyle(.bordered).tint(.indigo)
                    }.padding()
                }
            }
            .navigationTitle("AI-Voices")
            .refreshable {
                Task {
                    await manager.getVoices()
                }
            }
            .onAppear {
                Task {
                    await manager.getVoices()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        self.showSettings.toggle()
                    } label: {
                        Image(systemName: "gearshape")
                    }.buttonStyle(.bordered).tint(.indigo)
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(settings)
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    
    
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView(audioPlayer: AVAudioPlayer(data: nil))
//    }
//}
