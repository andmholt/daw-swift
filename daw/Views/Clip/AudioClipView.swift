//
//  AudioClip.swift
//  daw
//
//  Created by Andrew Holt on 1/2/23.
//

import SwiftUI
import AVFoundation

struct AudioClipView: View {
    
    @StateObject var vm: AudioClipViewModel
    
    let WAVEFORM_FREQ = 1200
    
//    var floatBuf: [Float]
    
    // temp
    var id = 0
    
    @State var location: CGFloat = 2
    
    init(vm: AudioClipViewModel) {
        // init
        self._vm = StateObject(wrappedValue: vm)
        
        // temp: get audio data
//        let url = Bundle.main.url(forResource: "snare", withExtension: "wav")
//        let file = try! AVAudioFile(forReading: url!)
//        let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate , channels: file.fileFormat.channelCount, interleaved: false)
//        let buf = AVAudioPCMBuffer(pcmFormat: format!, frameCapacity: UInt32(file.length))
//        try! file.read(into: buf!)
//        floatBuf = Array(UnsafeBufferPointer(start: buf!.floatChannelData![0], count:Int(buf!.frameLength)))
    }
    
    var body: some View {
        GeometryReader { metrics in
            VStack(spacing: 0) {
                
                // clip tab
                HStack {
                    Text(vm.title)
                }
                .frame(width: CGFloat(vm.floatBuf!.count)-Theme.clipPaddingL, height: Theme.clipTitleHAdj*metrics.size.height, alignment: .leading)
                .padding(.leading, Theme.clipPaddingL)
                .padding(.top, Theme.clipPaddingTB)
                .padding(.bottom, Theme.clipPaddingTB)
                .background(vm.color)
                .onHover { isHoveringTab in
                    vm.isHoveringTab = isHoveringTab
                }
                
                // draw waveform
                if let floatBuf = vm.floatBuf {
                    let waveH = metrics.size.height*(1-Theme.clipTitleHAdj)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: CGFloat(floatBuf[0]*(Float(waveH)/(-2)))+(waveH/2)))
                        var x = 1
                        for val in stride(from: 1, to: floatBuf.count, by: 2) {
                            path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(floatBuf[val]*(Float(waveH)/(-2)))+(waveH/2)))
                            x += 1
                        }
                    }
                    .frame(width: CGFloat(vm.floatBuf!.count))
                    .background(vm.color).opacity(0.8)
                }
            }
                .frame(height: metrics.size.height)
                .onHover { isHovering in
                    vm.onHover(isHovering: isHovering)
                }
        }
    }
}
