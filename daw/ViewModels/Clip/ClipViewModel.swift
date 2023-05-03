//
//  ClipViewVM.swift
//  daw
//
//  Created by Andrew Holt on 1/8/23.
//

import SwiftUI

class ClipViewModel: ObservableObject {
    @ObservedObject var clip = Clip()
    
    @Published var isHoveringTab: Bool = false
    var setHoveringClip: (ClipViewModel, Bool) -> Void
    
    init(setHoveringClip: @escaping (ClipViewModel, Bool) -> Void) {
        self.setHoveringClip = setHoveringClip
    }
    
    func onHover(isHovering: Bool) {
        self.setHoveringClip(self, isHovering)
    }
}
