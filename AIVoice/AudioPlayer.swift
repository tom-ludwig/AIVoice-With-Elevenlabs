//
//  AudioPlayer.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import SwiftUI

struct AudioPlayer: View {
    let data: Data
    var body: some View {
        AudioPlayerView(data: data)
    }
}
/*
struct AudioPlayer_Previews: PreviewProvider {
    static var previews: some View {
        AudioPlayer()
    }
}
*/
