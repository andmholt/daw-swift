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
    let audioPlayerNode2 = AVAudioPlayerNode()
    var audioPlayerNodes: [AVAudioPlayerNode] = []
    
    let audioFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: false)
    
    let audioFileURL = Bundle.main.url(forResource: "master", withExtension: "wav")!
    let audioFileURL2 = Bundle.main.url(forResource: "master", withExtension: "wav")!
    
    var audioBuffer: AVAudioPCMBuffer
    var audioBuffer2: AVAudioPCMBuffer
    
    let AUDIO_FRAME_COUNT = 4000000
    let AUDIO_NODE_COUNT = 10
    
    var currMergeBufId = 0
    
    var timer: Timer = Timer()
    
    var trackBuffs: [AVAudioPCMBuffer] = []
    var trackBuffCheck: [Bool] = []
    
    @Published var isPlaying = false
    
    @Published var playheadPos: Int = 0
    
    var playPos: Int = 0
    
    init() {
        // pre-attach audio nodes
//        print("Setting up audio nodes...")
//        for i in 0..<AUDIO_NODE_COUNT {
//            print("\(i)/\(AUDIO_NODE_COUNT)")
//            let newBuff = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: UInt32(AUDIO_FRAME_COUNT))!
//            let newNode = AVAudioPlayerNode()
//            let newUrl = Bundle.main.url(forResource: "_ finger gtr", withExtension: "wav")!
//
//        }
        
        audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: UInt32(AUDIO_FRAME_COUNT))!
        audioBuffer2 = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: UInt32(AUDIO_FRAME_COUNT))!
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(audioPlayerNode2)
        
        do {
            let audioFile = try AVAudioFile(forReading: audioFileURL)
            let audioFile2 = try AVAudioFile(forReading: audioFileURL2)
//            let audioFrameCount = UInt32(audioFile.length)
            let audioFrameCount = UInt32(AUDIO_FRAME_COUNT)
            audioBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: audioFrameCount)!
            try audioFile.read(into: audioBuffer)
            try audioFile2.read(into: audioBuffer2)
            audioEngine.connect(audioPlayerNode, to: audioEngine.mainMixerNode, format: audioFormat)
            audioEngine.connect(audioPlayerNode2, to: audioEngine.mainMixerNode, format: audioFormat)
//            try audioEngine.start()
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
            self.timer = Timer.scheduledTimer(withTimeInterval: Double(60)/Double(605), repeats: true) { timer in
                beginningOffset += 1
                if beginningOffset < 6 {
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
            
            let nodeScheduleTime = AVAudioTime(sampleTime: -startSampleTime, atRate: 48000)
            
            for (i, node) in self.audioPlayerNodes.enumerated() {
                node.scheduleBuffer(self.trackBuffs[i], at: nodeScheduleTime, options: .interruptsAtLoop) {
//                    if i == 0 {
//                        timer.invalidate()
//                    }
                }
            }
            
//            audioPlayerNode2.scheduleBuffer(audioBuffer2, at: nodeStartTime, options: .interruptsAtLoop)
            
//            audioPlayerNode.scheduleBuffer(audioBuffer, at: nodeStartTime, options: .interruptsAtLoop) {
//                // Completion handler
////                print("stopped")
//                timer.invalidate()
//            }

            // start audio engine
            try audioEngine.start()
            
            // schedule all nodes for 0.5 seconds into the future, to let all be triggered at the same time
            let nodePlayTime = AVAudioTime(hostTime: mach_absolute_time() + UInt64(0.25 * Double(NSEC_PER_SEC)))
            
            // play all nodes
            for node in self.audioPlayerNodes {
                node.play(at: nodePlayTime)
            }
//            audioPlayerNode.play()
//            audioPlayerNode2.play()
            
        } catch let error {
            print("Error loading audio: \(error.localizedDescription)")
        }
        
    }
    
    func stop() {
        // set isPlaying
//        isPlaying = false
//        audioEngine.stop()
        for node in self.audioPlayerNodes {
            node.stop()
        }
        self.timer.invalidate()
        playheadPos = 0
    }
    
    func getMergeBufId() -> Int {
        currMergeBufId += 1
        self.trackBuffs.append(AVAudioPCMBuffer())
        return currMergeBufId-1
    }
    
    func mergeBuf(newBuf: AVAudioPCMBuffer, bufId: Int) {
        
        // if tnot enough nodes, create a new one
        if bufId >= self.audioPlayerNodes.count {
            print("Loading track \(bufId)")
            let newNode = AVAudioPlayerNode()
            self.audioPlayerNodes.append(newNode)
            self.audioEngine.attach(newNode)
            self.audioEngine.connect(newNode, to: self.audioEngine.mainMixerNode, format: self.audioFormat)
        }
        
//        let currBuffCount: Float = Float(currMergeBufId)
        
        // read a file into the buffer to set up the buffer properly
        let tempUrl = Bundle.main.url(forResource: "master", withExtension: "wav")!
        let tempBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat!, frameCapacity: UInt32(AUDIO_FRAME_COUNT))!
        let tempFile = try! AVAudioFile(forReading: tempUrl)
        try! tempFile.read(into: tempBuffer)
        
        // write this track's data to the tempBuffer
        for i in stride(from: 0, to: AUDIO_FRAME_COUNT, by: 1) {
            // left
            tempBuffer.floatChannelData![0][i] = newBuf.floatChannelData![0][i]
            // right
            tempBuffer.floatChannelData![1][i] = newBuf.floatChannelData![1][i]
        }
        
        // save this buffer
        self.trackBuffs[bufId] = tempBuffer
    }
}
