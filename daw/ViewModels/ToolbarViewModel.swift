//
//  ToolbarViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/9/23.
//

import SwiftUI
import AVFoundation

class ToolbarViewModel: ObservableObject {
    
    // bpm
    @Published var bpm: Float = 110
    @Published var isChangingBpm: Bool = false
    
    // time signature
    @Published var timeSignatureTop: Int = 4
    @Published var timeSignatureBottom: Int = 4
    @Published var isChangingTimeSignatureTop: Bool = false
    @Published var isChangingTimeSignatureBottom: Bool = false
    
    // play
    @Published var isPlaying: Bool = false
    
    // record
    @Published var isRecording: Bool = false
    
    var sendPlay: () -> Void
    var sendStop: () -> Void
    
    init(play: @escaping () -> Void, stop: @escaping () -> Void) {
        self.sendPlay = play
        self.sendStop = stop
    }
    
    func play() {
        isPlaying = true
        sendPlay()
    }
    
    func stop() {
        isPlaying = false
        sendStop()
    }
}
