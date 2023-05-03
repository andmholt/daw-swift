//
//  ContentViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/20/23.
//

import SwiftUI
import AVFoundation

class ContentViewModel: ObservableObject {
    
    // audio engine
    let audioEngine = AVAudioEngine()
    let audioPlayerNode = AVAudioPlayerNode()
    
    let audioFileURL = Bundle.main.url(forResource: "_ hats", withExtension: "wav")!
    
    var audioBuffer: AVAudioPCMBuffer
    
    let AUDIO_FRAME_COUNT = 4000000
    
    var currMergeBufId = 0
    
    var trackBuffs: [AVAudioPCMBuffer] = []
    var trackBuffCheck: [Bool] = []
    
    @Published var isPlaying = false
    
    @Published var playheadPos = 0
    
    var playPos: Int = 0
    
    init() {
        let pcmFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: false)
        audioBuffer = AVAudioPCMBuffer(pcmFormat: pcmFormat!, frameCapacity: UInt32(AUDIO_FRAME_COUNT))!
        audioEngine.attach(audioPlayerNode)
        
        do {
            let audioFile = try AVAudioFile(forReading: audioFileURL)
            let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: false)
//            let audioFrameCount = UInt32(audioFile.length)
            let audioFrameCount = UInt32(AUDIO_FRAME_COUNT)
            audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: audioFrameCount)!
            try audioFile.read(into: audioBuffer)
            audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
            try audioEngine.start()
            print("FINISHED LOADING \(audioFrameCount)")
        } catch let error {
            print("Error loading audio: \(error.localizedDescription)")
        }
    }
    
    func setPlayPos(pos: Int) {
        self.playPos = pos
    }
    
    func play() {
        // set isPlaying
//        isPlaying = true
        
        do {
//            let audioFile = try AVAudioFile(forReading: audioFileURL)
//            let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: false)
//            let audioFrameCount = UInt32(audioFile.length)
//            guard let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: audioFrameCount) else { return }
//            try audioFile.read(into: audioBuffer)

//            for i in stride(from: 0, to: Int(audioFrameCount), by: 1) {
//                print("NEW L: \(audioBuffer.floatChannelData![0][i]), R: \(audioBuffer.floatChannelData![1][i])")
//            }
            
            var beginningOffset = 0
            self.playheadPos = playPos*11
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                beginningOffset += 1
                if beginningOffset < 2 {
                    return
                }
                // This code will be executed every 0.25 seconds
                self.playheadPos += 2
            }
            
            let samplesPerSecond = 48000
            let beatsPerMinute = 110
            let beatsPerSecond: Float = Float(beatsPerMinute)/60
            let samplesPerBeat = Float(samplesPerSecond)/beatsPerSecond
            let startSampleTime = AVAudioFramePosition(Int(Float(playPos) * samplesPerBeat))
            
            audioPlayerNode.scheduleBuffer(audioBuffer, at: AVAudioTime(sampleTime: -startSampleTime, atRate: 48000), options: .interruptsAtLoop) {
                // Completion handler
//                print("stopped")
                timer.invalidate()
            }

//            try audioEngine.start()
            audioPlayerNode.play()
            
        } catch let error {
            print("Error loading audio: \(error.localizedDescription)")
        }
        
    }
    
    func stop() {
        // set isPlaying
//        isPlaying = false
//        audioEngine.stop()
        audioPlayerNode.stop()
        playheadPos = 0
    }
    
    func getMergeBufId() -> Int {
        currMergeBufId += 1
        trackBuffCheck.append(false)
        return currMergeBufId-1
    }
    
    func mergeBuf(newBuf: AVAudioPCMBuffer, bufId: Int) {
        let currBuffCount: Float = Float(currMergeBufId)
        
        if trackBuffCheck[bufId] == false {
            trackBuffs.append(newBuf)
            trackBuffCheck[bufId] = true
        }
        
        for i in stride(from: 0, to: AUDIO_FRAME_COUNT, by: 1) {
            // left
            audioBuffer.floatChannelData![0][i] = 0
            // right
            audioBuffer.floatChannelData![1][i] = 0

//            if (i % 1000 == 0) {
//                print("\(i) L: \(audioBuffer.floatChannelData![0][i]), R: \(audioBuffer.floatChannelData![1][i])")
//            }
        }

        for j in stride(from: 0, to: Int(currBuffCount), by: 1) {
            for i in stride(from: 0, to: AUDIO_FRAME_COUNT, by: 1) {
                // left
                let leftFloat = trackBuffs[j].floatChannelData![0][i]/currBuffCount
                audioBuffer.floatChannelData![0][i] += leftFloat
                // right
                let rightFloat = trackBuffs[j].floatChannelData![1][i]/currBuffCount
                audioBuffer.floatChannelData![1][i] += rightFloat

//                if (i % 24000 == 0) {
//                    print("clip \(j) i:\(i) L: \(audioBuffer.floatChannelData![0][i]), R: \(audioBuffer.floatChannelData![1][i])")
//                }
            }
        }
        
//        let sampleRate: Double = 44800
//        let duration = 5.0
//        let frequency = 440.0
//
//        let totalFrames = UInt32(sampleRate * duration)
//        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: Double(sampleRate), channels: 2)
//
//        let audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: totalFrames)!
//
//        let halfCycleFrames = UInt32(sampleRate / frequency / 2)
//        let samplesPerHalfCycle = UInt32(audioFormat!.streamDescription.pointee.mBytesPerFrame) / UInt32(3)
//
//        for i in 0..<10000 {
//            print("HI")
//            let sampleValue: Float
//            if (i / Int(halfCycleFrames)) % 2 == 0 {
//                sampleValue = 1.0
//            } else {
//                sampleValue = -1.0
//            }
//            for j in 0..<samplesPerHalfCycle {
//                audioBuffer.floatChannelData![0][i * Int(samplesPerHalfCycle) + Int(j)] = sampleValue
//            }
//        }
    }
}
