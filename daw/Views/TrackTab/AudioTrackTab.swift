//
//  AudioTrackTab.swift
//  daw
//
//  Created by Andrew Holt on 12/31/22.
//

import SwiftUI
 
/*
 needs to control:
 - solo
 - mute
 - volume
 - panning
 
 aesthetic controls:
 - color
 - name
 - background design/picture
 
*/

struct AudioTrackTab: View {
    
    @StateObject var vm: AudioTrackViewModel
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                
                // track title
                if vm.isEditingTrackTitle {
                    TextField(vm.title, text: $vm.title)
                        .onSubmit {
                            vm.isEditingTrackTitle = false
                        }
                } else {
                    Text(vm.title)
                        .onTapGesture(count: 2) {
                            vm.isEditingTrackTitle = true
                        }
                }
                
                // SMR
                HStack(spacing: 0) {
                    Button("S") {
                        vm.isSolo.toggle()
                    }
                        .background(vm.isSolo ? .white : .white.opacity(0))
                        .foregroundColor(vm.isSolo ? .pink : .white)
                        .clipShape(Circle())
                    Button("M") {
                        vm.isMute.toggle()
                    }
                        .background(vm.isMute ? .white : .white.opacity(0))
                        .foregroundColor(vm.isMute ? .pink : .white)
                        .clipShape(Circle())
                    Button("R") {
                        vm.isRecord.toggle()
                    }
                        .background(vm.isRecord ? .white : .white.opacity(0))
                        .foregroundColor(vm.isRecord ? .pink : .white)
                        .clipShape(Circle())
                }
                
            }
                .frame(width: metrics.size.width, height: metrics.size
                        .height)
                .background(vm.tabColor)
                .contextMenu {
                    Button("Delete") {
                        vm.deleteTrack(vm.track.id)
                    }
                }
        }
    }
}
