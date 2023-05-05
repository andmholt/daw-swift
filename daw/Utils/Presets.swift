import SwiftUI

let voxColor: Color = .purple
let gtrColor: Color = .indigo

struct PresetTrack {
    let title: String
    let color: Color
    let clipFiles: [String]
    let clipLocations: [CGFloat]
}

struct MetronomeTest {
    let tracks = [
        PresetTrack(title: "metr", color: voxColor, clipFiles: [
            "metr",
            "metr",
        ], clipLocations: [
            1.5,
            5,
        ]),
    ]
}

struct TalkLikeTest {
    let tracks = [
        
        // vox
        
        // gtr
        PresetTrack(title: "Finger Guitar", color: gtrColor, clipFiles: [
            "finger gtr 0",
            "finger gtr 1"
        ], clipLocations: [
            0,
            37.5
        ])
        
    ]
}
