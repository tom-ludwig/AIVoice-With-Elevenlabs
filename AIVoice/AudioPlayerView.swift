//
//  AudioPlayerView.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import SwiftUI
import AVKit

struct AudioPlayerView: UIViewControllerRepresentable {
    let data: Data
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: URL(dataRepresentation: data, relativeTo: nil)!)
        let controller = AVPlayerViewController()
        controller.player = player
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
