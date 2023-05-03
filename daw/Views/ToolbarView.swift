//
//  ToolbarView.swift
//  daw
//
//  Created by Andrew Holt on 1/9/23.
//

import SwiftUI

struct ToolbarView: View {
    @StateObject var vm: ToolbarViewModel
    
    let GROUPBOX_H: CGFloat = 30
    let BPM_W: CGFloat = 70
    let TIMESIGNATURE_W: CGFloat = 30
    
    init(vm: ToolbarViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        GeometryReader { metrics in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    GroupBox() {
                        HStack {
                            // bpm
                            HStack {
                                if vm.isChangingBpm {
                                    TextField("bpm", value: $vm.bpm, formatter: NumberFormatter())
                                        .onSubmit {
                                            vm.isChangingBpm = false
                                        }
                                        .frame(width: BPM_W)
                                } else {
                                    Text(String(vm.bpm) + "bpm")
                                }
                            }
                            .onTapGesture(count: 2) {
                                vm.isChangingBpm = true
                            }
                            Divider().frame(width: 1).overlay(.black)
                            // time signature
                            HStack {
                                if vm.isChangingTimeSignatureTop {
                                    TextField("", value: $vm.timeSignatureTop, formatter: NumberFormatter())
                                        .onSubmit {
                                            vm.isChangingTimeSignatureTop = false
                                        }
                                        .frame(width: TIMESIGNATURE_W)
                                } else {
                                    Text(String(vm.timeSignatureTop))
                                }
                            }
                            .onTapGesture(count: 2) {
                                vm.isChangingTimeSignatureTop = true
                            }
                            Text("/")
                            HStack {
                                if vm.isChangingTimeSignatureBottom {
                                    TextField("", value: $vm.timeSignatureBottom, formatter: NumberFormatter())
                                        .onSubmit {
                                            vm.isChangingTimeSignatureBottom = false
                                        }
                                        .frame(width: TIMESIGNATURE_W)
                                } else {
                                    Text(String(vm.timeSignatureBottom))
                                }
                            }
                            .onTapGesture(count: 2) {
                                vm.isChangingTimeSignatureBottom = true
                            }.keyboardShortcut("1")
                        }
                        .padding(.leading, 5)
                        .padding(.trailing, 5)
                    }
                    .background(.ultraThinMaterial)
                }
                .frame(height: metrics.size.height-Theme.outsidePadding)
                
                // spacer
                Spacer().frame(width: Theme.outsidePadding)
                
                // play
                if vm.isPlaying {
                    Rectangle()
                        .frame(width: 22.5, height: 22.5)
                        .foregroundColor(.gray.opacity(0.4))
                        .background(.black.opacity(0))
                        .onTapGesture {
                            vm.stop()
                        }
                } else {
                    PlayShape()
                        .frame(width: 22.5, height: 22.5)
                        .foregroundColor(.gray.opacity(0.4))
                        .background(.black.opacity(0))
                        .onTapGesture {
                            vm.play()
                        }
                }
                
                // spacer
                Spacer().frame(width: Theme.outsidePadding)
                
                // record
                if vm.isRecording {
                    Ellipse()
                        .frame(width: 22.5, height: 22.5)
                        .foregroundColor(.red)
                        .background(.black.opacity(0))
                        .onTapGesture {
                            vm.isRecording = false
                        }
                } else {
                    Ellipse()
                        .frame(width: 22.5, height: 22.5)
                        .foregroundColor(.gray.opacity(0.4))
                        .background(.black.opacity(0))
                        .onTapGesture {
                            vm.isRecording = true
                        }
                }
            }
            .frame(width: metrics.size.width, height: metrics.size.height-Theme.outsidePadding, alignment: .leading)
            .padding(.bottom, Theme.outsidePadding)
        }
    }
}

struct PlayShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: (rect.maxY/2)))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        return path
    }
}
