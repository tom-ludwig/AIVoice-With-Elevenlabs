//
//  ListView.swift
//  AIVoice
//
//  Created by Tommy Ludwig on 12.04.23.
//

import SwiftUI

struct ListView: View {
    let voices: [Voice]
    @Binding var selectedVoiceID: String
    var body: some View {
        List {
            ForEach(voices, id: \.id) { voice in
                Button {
                    withAnimation() {
                        self.selectedVoiceID = voice.voiceID ?? "21m00Tcm4TlvDq8ikWAM"
                    }
                } label: {
                    HStack {
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .frame(width: 20)
                            .overlay {
                                if voice.voiceID == selectedVoiceID {
                                    Circle()
                                        .foregroundStyle(.indigo)
                                        .frame(width: 15)
                                }
                            }
                        Text("\(voice.name ?? "No name given")")
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(voice.voiceID ?? "No ID given")")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .fontDesign(.monospaced)
                }
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(voices: [], selectedVoiceID: .constant("21m00Tcm4TlvDq8ikWAM"))
    }
}
