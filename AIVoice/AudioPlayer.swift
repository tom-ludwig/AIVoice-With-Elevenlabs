//
//  AudioPlayer.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import SwiftUI
import AVFoundation
import DSWaveformImage
import DSWaveformImageViews

struct AudioPlayer: View {
    @State var data: Data?
    @State var audioPlayer: AVAudioPlayer?
    @State var audioFileURL: URL?
    @State var configuration: Waveform.Configuration = Waveform.Configuration(
        style: .striped(.init(color: .lightGray, width: 5, spacing: 2, lineCap: .round)),
        verticalScalingFactor: 1
    )
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
                    
                    if let url = audioFileURL {
                        WaveformView(audioURL: url, configuration: configuration)
                    } else {
                        ProgressView()
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
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            let fileURL = documentsDirectory.appendingPathComponent("audio.m4a")
            do {
                try data?.write(to: fileURL, options: .atomic)
                print("Data succsesfully saved!")
            } catch {
                print("Error writing data to file: \(error)")
            }
            self.audioFileURL = fileURL
        }
        .padding()
    }
}

//struct AudioPlayer_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioPlayer()
//    }
//}
