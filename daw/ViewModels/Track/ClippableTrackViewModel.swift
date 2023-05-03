//
//  ClippableTrackViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/8/23.
//

import SwiftUI
import AVFoundation

class ClippableTrackViewModel: TrackViewModel {
    @Published var clips: [ClipViewModel] = []
    @Published var clipLocations: [UUID: CGFloat] = [:]
    var setHoveringClip: (ClipViewModel, Bool) -> Void
    
    // SMR
    @Published var isSolo: Bool = false
    @Published var isMute: Bool = false
    @Published var isRecord: Bool = false
    
    var getMergeBufId: () -> Int
    var mergeBuf: (AVAudioPCMBuffer, Int) -> Void
    
    init(setHoveringTrack: @escaping (TrackViewModel, Bool) -> Void,
         setHoveringClip: @escaping (ClipViewModel, Bool) -> Void,
         deleteTrack: @escaping (UUID) -> Void,
         getMergeBufId: @escaping () -> Int,
         mergeBuf: @escaping (AVAudioPCMBuffer, Int) -> Void) {
        self.setHoveringClip = setHoveringClip
        self.getMergeBufId = getMergeBufId
        self.mergeBuf = mergeBuf
        super.init(setHoveringTrack: setHoveringTrack, deleteTrack: deleteTrack)
    }
    
    func insertClip(newClip: ClipViewModel, at location: CGFloat) {
        self.clips.append(newClip)
        self.clipLocations[newClip.clip.id] = location
    }
}
