//
//  TracksView.swift
//  daw
//
//  Created by Andrew Holt on 12/29/22.
//

import SwiftUI
import AVFoundation

struct TracksView: View {
    
    @StateObject public var vm: TracksViewModel
    
    @Binding var playheadPos: Int
    
    // constants
    let SPACER_HEIGHT: CGFloat = 10
    
    let TRACKS_WIDTH: CGFloat = 10000
    
    init(getMergeBufId: @escaping () -> Int, mergeBuf: @escaping (AVAudioPCMBuffer, Int) -> Void, playheadPos: Binding<Int>, setPlayPos: @escaping (Int) -> Void) {
        self._playheadPos = playheadPos
        self._vm = StateObject(wrappedValue: TracksViewModel(getMergeBufId: getMergeBufId, mergeBuf: mergeBuf, setPlayPos: setPlayPos))
    }
    
    var body: some View {
        GeometryReader { metrics in
            
            VStack(spacing: 0) {
                // ruler
                ScrollView(.horizontal) {
                    // ruler
                    ZStack() {
                        // numbers
                        HStack(spacing: 0) {
                            ForEach (0...69, id: \.self) { i in
                                Text(String(i))
                                    .foregroundColor(.gray)
                                    .frame(width: CGFloat(vm.gridScale*4), alignment: .leading)
                            }
                        }
                        .frame(width: TRACKS_WIDTH, height: CGFloat(Theme.rulerH), alignment: .topLeading)
                        // lines
                        Path { path in
                            for i in 0..<1000 {
                                // tall vs short lines
                                if i % 4 == 0 {
                                    path.move(to: CGPoint(x: i*Int(vm.gridScale), y: Int(Theme.rulerH/2)))
                                } else {
                                    path.move(to: CGPoint(x: i*Int(vm.gridScale), y: Int(Theme.rulerH-(Theme.rulerH/4))))
                                }
                                path.addLine(to: CGPoint(x: i*Int(vm.gridScale), y: Int(Theme.rulerH)))
                            }
                        }
                        .stroke(.gray, lineWidth: 1)
                        .frame(width: TRACKS_WIDTH, height: Theme.rulerH)
                    }
                    .frame(width: TRACKS_WIDTH, height: Theme.rulerH)
                    .background(.ultraThinMaterial)
                    .offset(x: -vm.horizontalScrollOffset)
                }
                .disabled(true)
                .frame(width: metrics.size.width-Theme.trackTabW)
                .padding(.leading, Theme.trackTabW)
                .padding(.bottom, SPACER_HEIGHT)
                .background(.black)
                
                ScrollView(.vertical) {
                    HStack(spacing: 0) {
                        
                        // left side
                        VStack(spacing: 0) {
                            
                            // track tabs
                            ForEach(vm.tracks, id: \.self.track.id) { trackViewModel in
                                AudioTrackTab(vm: trackViewModel as! AudioTrackViewModel)
                                    .frame(width: Theme.trackTabW, height: Theme.trackH)
                                    .border(.black)
                            }
                            
                            Spacer().frame(height: SPACER_HEIGHT)
                            
                            // add track
                            Button("+") {
                                vm.addTrack()
                            }
                            
                        }
                        .frame(width: Theme.trackTabW, height: (metrics.size.height-Theme.rulerH-SPACER_HEIGHT) > (CGFloat(vm.tracks.count)*Theme.trackH) ? metrics.size.height-Theme.rulerH-SPACER_HEIGHT : CGFloat(vm.tracks.count)*Theme.trackH, alignment: .topLeading)
                        
                        // ruler and track content horizontal scroll
                        CustomScrollView(axes: .horizontal, offsetChanged: { offset in
                            vm.horizontalScrollOffset = (TRACKS_WIDTH/2)-(offset.x)}) {
                            VStack(alignment: .leading, spacing: 0) {
                                
                                // track content
                                ZStack(alignment: .topLeading) {
                                    
                                    // grid lines
                                    Path { path in
                                        for i in 0..<1000 {
                                            path.move(to: CGPoint(x: i*Int(vm.gridScale), y: 0))
                                            path.addLine(to: CGPoint(x: i*Int(vm.gridScale), y: Int(CGFloat(vm.tracks.count)*Theme.trackH)))
                                        }
                                    }
                                    .stroke(.gray, lineWidth: 1)
                                    .frame(width: metrics.size.width-Theme.trackTabW, height: metrics.size.height-SPACER_HEIGHT-Theme.rulerH)
                                    
                                    // playhead
                                    Path { path in
                                        path.move(to: CGPoint(x: playheadPos, y: 0))
                                        path.addLine(to: CGPoint(x: playheadPos, y: Int(CGFloat(vm.tracks.count)*Theme.trackH)))
                                    }
                                    .stroke(.white, lineWidth: 3)
                                    .zIndex(1)
                                    .frame(width: metrics.size.width-Theme.trackTabW, height: metrics.size.height-SPACER_HEIGHT-Theme.rulerH)
                                    
                                    // tracks contents
                                    VStack(alignment: .leading, spacing: 0) {
                                        ForEach(vm.tracks, id: \.self.track.id) { trackViewModel in
                                            
                                            // audio track
                                            AudioTrackView(vm: trackViewModel as! AudioTrackViewModel)
                                                .frame(width: TRACKS_WIDTH, height: Theme.trackH)
                                                .border(.black)
                                        }
                                    }
                                    .background(.black.opacity(0.5))
                                    
                                    // highlight
                                    if let topLeftHighlight = vm.topLeftHighlight, let bottomLeftHighlight = vm.bottomLeftHighlight, let topRightHighlight = vm.topRightHighlight, let bottomRightHighlight = vm.bottomRightHighlight {
                                        Path { path in
                                            // draw highlight
                                            path.move(to: topLeftHighlight)
                                            path.addLine(to: bottomLeftHighlight)
                                            path.addLine(to: bottomRightHighlight)
                                            path.addLine(to: topRightHighlight)
                                            path.addLine(to: topLeftHighlight)
                                        }
                                        .fill(.white).opacity(0.4)
                                    }
                                    // cursor line
                                    else if let cursorLineTop = vm.cursorLineTop,
                                            let cursorLineBottom = vm.cursorLineBottom {
                                        Path { path in
                                            // draw cursor line
                                            path.move(to: cursorLineTop)
                                            path.addLine(to: cursorLineBottom)
                                        }
                                        .stroke(.white, lineWidth: 2)
                                    }
                                }
                                .gesture(
                                    DragGesture()
                                        .onChanged { gesture in
                                            vm.onDragGesture(start: gesture.startLocation, curr: gesture.location)
                                        }
                                        .onEnded { _ in
                                            vm.onDragGestureEnded()
                                            vm.clipDragStartLoc = nil
//                                            vm.saveClipBufLoc()
                                        }
                                )
                                .onTapGesture { gesture in
                                    vm.onTapGesture(gesture)
                                }
                                .gesture(
                                    MagnificationGesture()
                                        .onChanged { magnification in
                                            vm.onMagnificationGesture(magnification)
                                        }
                                )
                            }
                            .offset(y: -4)
                        }
                        .frame(width: metrics.size.width-Theme.trackTabW, height: metrics.size.height-Theme.rulerH-SPACER_HEIGHT)
                    }
                    .frame(height: (CGFloat(vm.tracks.count+1)*Theme.trackH), alignment: .top)
                }
                .frame(width: metrics.size.width, height: metrics.size.height-Theme.rulerH-SPACER_HEIGHT)
                .border(.black, width: 2)
                .background(.ultraThinMaterial)
            }
            .frame(width: metrics.size.width, height: metrics.size.height)
            .background(.black)
        }
    }
}
