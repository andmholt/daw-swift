//
//  AudioTrackViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/8/23.
//

import SwiftUI
import AVFoundation

@MainActor class AudioTrackViewModel: ClippableTrackViewModel {
    
    var audioBuffer: AVAudioPCMBuffer
    var mergeBufId: Int
    
    var clipSize: UInt32?

    @Published var tabColor: Color
    @Published var title: String
    
    let AUDIO_FRAME_COUNT = 4000000
    
    init(setHoveringTrack: @escaping (TrackViewModel, Bool) -> Void,
         setHoveringClip: @escaping (ClipViewModel, Bool) -> Void,
         deleteTrack: @escaping (UUID) -> Void,
         getMergeBufId: @escaping () -> Int,
         mergeBuf: @escaping (AVAudioPCMBuffer, Int) -> Void,
         audioFiles: [String],
         clipLocations: [CGFloat],
         tabColor: Color,
         title: String) {
        
        // tab color
        self.tabColor = tabColor
        
        // track title
        self.title = title
        
        // audio buf
        let pcmFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: false)
        audioBuffer = AVAudioPCMBuffer(pcmFormat: pcmFormat!, frameCapacity: UInt32(AUDIO_FRAME_COUNT))!
        
        // get merge id
        mergeBufId = getMergeBufId()
        
        super.init(setHoveringTrack: setHoveringTrack, setHoveringClip: setHoveringClip, deleteTrack: deleteTrack, getMergeBufId: getMergeBufId, mergeBuf: mergeBuf)
        
        for (i, _) in audioFiles.enumerated() {
            print("CREATING CLIP \(i)")
            self.clips.append(AudioClipViewModel(setHoveringClip: self.setHoveringClip, attachBuf: self.attachBuf, audioFile: audioFiles[i], location: clipLocations[i], color: self.tabColor, title: self.title))
        }
        
//        self.clips = [
//            AudioClipViewModel(setHoveringClip: self.setHoveringClip, attachBuf: self.attachBuf, audioFile: audioFiles[0], location: clipLocations[0], color: self.tabColor, title: self.title)
//        ]
    }
    
    func attachBuf(id: UUID, clipBuffer: AVAudioPCMBuffer, location: CGFloat, size: UInt32) {
        let beatNumber = location * 4
        let samplesPerSecond = 48000
        let beatsPerMinute = 110
        let beatsPerSecond: Float = Float(beatsPerMinute)/60
        let samplesPerBeat = Float(samplesPerSecond)/beatsPerSecond
        let sampleLocation = Int(Float(beatNumber) * samplesPerBeat)
        clipSize = size
        if (Int(size)+sampleLocation > AUDIO_FRAME_COUNT) {
            print("ERROR: size \(size) + location \(sampleLocation) greater than AUDIO_FRAME_COUNT \(AUDIO_FRAME_COUNT)")
        }
        for i in stride(from: 0, to: Int(size), by: 1) {
//            if (i+location >= audioBuffer.frameLength) {
//                break
//            }
            // left
            audioBuffer.floatChannelData![0][i+sampleLocation] = clipBuffer.floatChannelData![0][i]
            // right
            audioBuffer.floatChannelData![1][i+sampleLocation] = clipBuffer.floatChannelData![1][i]
        }
        
        // merge to audio engine
        self.mergeBuf(audioBuffer, mergeBufId)
        
        // set location
        self.clipLocations[id] = location
    }
    
    func updateBufLocations() {
        
        // clear buff
        for i in stride(from: 0, to: AUDIO_FRAME_COUNT, by: 1) {
            // left
            audioBuffer.floatChannelData![0][i] = 0
            // right
            audioBuffer.floatChannelData![1][i] = 0
        }
        
        // some constants
        let samplesPerSecond = 48000
        let beatsPerMinute = 110
        let beatsPerSecond: Float = Float(beatsPerMinute)/60
        let samplesPerBeat = Float(samplesPerSecond)/beatsPerSecond
        let size = clipSize!
        
        // for each clip in the audio track
        for clip in self.clips {
            let beatNum = Int(self.clipLocations[clip.clip.id]! * 4)
            let location = Int(Float(beatNum) * samplesPerBeat)
            
            if (Int(size)+location > AUDIO_FRAME_COUNT) {
                print("ERROR: size \(size) + location \(location) greater than AUDIO_FRAME_COUNT \(AUDIO_FRAME_COUNT)")
            }
            
            // get clip buffer
            let clipBuffer = (clip as! AudioClipViewModel).audioBuffer
            
            // write clip to track buff
            for i in stride(from: 0, to: Int(size), by: 1) {
                // left
                audioBuffer.floatChannelData![0][i+location] = clipBuffer!.floatChannelData![0][i]
                // right
                audioBuffer.floatChannelData![1][i+location] = clipBuffer!.floatChannelData![1][i]
            }
            print("updated buf to location \(location), \(Int(self.clipLocations[self.clips[0].clip.id]!))")
        }
        
        // merge to audio engine
        self.mergeBuf(audioBuffer, mergeBufId)
    }
}
