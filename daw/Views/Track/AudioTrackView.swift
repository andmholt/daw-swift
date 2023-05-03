//
//  TrackContent.swift
//  daw
//
//  Created by Andrew Holt on 1/2/23.
//

import SwiftUI

struct AudioTrackView: View {
    
    @StateObject var vm: AudioTrackViewModel
    
    init(vm: AudioTrackViewModel) {
        self._vm = StateObject(wrappedValue: vm)
    }
    
    var body: some View {
        GeometryReader { metrics in
            HStack {
                /*ForEach (Array(zip(vm.clips.indices, vm.clips)), id: \.1.clip.id) { i, clipVM in
                    AudioClipView(vm: clipVM as! AudioClipViewModel)
                        .offset(x: vm.clipLocations[clipVM.clip.id] ?? 0)
                }*/
                ForEach (vm.clips, id: \.self.clip.id) { clipVM in
                    AudioClipView(vm: clipVM as! AudioClipViewModel)
                        .offset(x: vm.clipLocations[clipVM.clip.id] ?? 0)
                }
            }
                .frame(width: metrics.size.width, height: metrics.size.height)
                .onHover { isHovering in
                    vm.onHover(isHovering: isHovering)
                }
        }
    }
}
