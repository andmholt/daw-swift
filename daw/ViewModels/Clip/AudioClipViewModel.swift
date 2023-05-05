//
//  AudioClipViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/8/23.
//

import SwiftUI
import AVFoundation

@MainActor class AudioClipViewModel: ClipViewModel {
    
    let WAVEFORM_FREQ = 1200
    
    @Published var floatBuf: [Float]?
    var audioBuffer: AVAudioPCMBuffer?
    
    var attachBuf: (UUID, AVAudioPCMBuffer, CGFloat, UInt32) -> Void
    var length: UInt32 = 0
    
    @Published var color: Color
    @Published var title: String
    
    init(setHoveringClip: @escaping (ClipViewModel, Bool) -> Void,
         attachBuf: @escaping (UUID, AVAudioPCMBuffer, CGFloat, UInt32) -> Void,
         audioFile: String,
         location: CGFloat,
         color: Color,
         title: String) {
        
        // color
        self.color = color
        
        // title
        self.title = title
        
        self.attachBuf = attachBuf
        super.init(setHoveringClip: setHoveringClip)
        self.clip = AudioClip()
        
        // read audio data
        do {
            let audioFileURL = Bundle.main.url(forResource: audioFile, withExtension: "wav")!
            let audioFile = try AVAudioFile(forReading: audioFileURL)
            let audioFormat = audioFile.processingFormat
            // current default size to 10 million
//            let audioFrameCount = UInt32(10000000)
            let audioFrameCount = UInt32(audioFile.length)
            self.length = audioFrameCount
            audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
            try audioFile.read(into: audioBuffer!)
            
            // save to viewBuf for drawing the waveform on the screen
            floatBuf = Array(UnsafeBufferPointer(start: audioBuffer!.floatChannelData![0], count:(Int(audioBuffer!.frameLength)/WAVEFORM_FREQ)+1))
            
            var i = 0
            for val in stride(from: 0, to: audioBuffer!.frameLength, by: WAVEFORM_FREQ) {
                floatBuf?[i] = audioBuffer!.floatChannelData![0][Int(val)];
                i += 1
            }
            
            // attach to track buffer
            attachBuf(self.clip.id, audioBuffer!, location, audioFrameCount)
        } catch let error {
            print("Error loading audio: \(error.localizedDescription)")
        }
    }
    
}
