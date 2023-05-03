//
//  TrackViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/8/23.
//

import SwiftUI

class TrackViewModel: ObservableObject {
    @ObservedObject var track: Track = Track()
    
    var deleteTrack: (UUID) -> Void
    
    // track tab
    @Published var isEditingTrackTitle: Bool = false
    
    var setHoveringTrack: (TrackViewModel, Bool) -> Void
    
    init(setHoveringTrack: @escaping (TrackViewModel, Bool) -> Void, deleteTrack: @escaping (UUID) -> Void) {
        self.setHoveringTrack = setHoveringTrack
        self.deleteTrack = deleteTrack
    }
    
    func onHover(isHovering: Bool) {
        self.setHoveringTrack(self, isHovering)
    }
}
