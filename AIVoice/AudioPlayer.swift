//
//  AudioPlayer.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import SwiftUI
import AVFoundation

struct AudioPlayer: View {
    @State var data: Data?
    @State var audioPlayer: AVAudioPlayer?
    var body: some View {
        VStack {
            if let audioPlayer = audioPlayer {
                HStack {
                        Button {
                            audioPlayer.play()
                        } label: {
                            Image(systemName: "play")
                        }.buttonStyle(.bordered).tint(.indigo)
                        
                        Button {
                            audioPlayer.pause()
                        } label: {
                            Image(systemName: "pause")
                        }.buttonStyle(.bordered).tint(.indigo)
                    
                    VStack(alignment: .leading) {
                        Text("The Audio is ready")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        
                        Text("Check your volume to hear something")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                        Spacer()
                    }
                }.frame(height: 40)
            }
        }.onAppear {
            do {
                if let data = data {
                    audioPlayer = try AVAudioPlayer(data: data)
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                    print("Ready to play!")
                } else {
                    print("data == nil")
                }
            } catch {
                print("Error while loading audio data: \(error.localizedDescription)")
            }
        }
        .padding()
    }
}

//struct AudioPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioPlayer()
//    }
//}
