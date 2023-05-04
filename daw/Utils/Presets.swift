import SwiftUI

let voxColor: Color = .purple
let gtrColor: Color = .indigo

struct PresetTrack {
    let title: String
    let color: Color
    let clipFiles: [String]
    let clipLocations: [Int]
}

struct MetronomeTest {
    let tracks = [
        PresetTrack(title: "metr", color: voxColor, clipFiles: [
            "metr",
            "metr"
        ], clipLocations: [
            0,
            20
        ]),
    ]
}

struct TalkLikeTest {
    let tracks = [
        
        // vox
        PresetTrack(title: "Intro Vox", color: voxColor, clipFiles: [
            "_ intro vox",
        ], clipLocations: [
            0,
        ]),
        PresetTrack(title: "Verse Vox", color: voxColor, clipFiles: [
            "_ verse vox",
        ], clipLocations: [
            0,
        ]),
        
        // gtr
        PresetTrack(title: "Finger Guitar", color: gtrColor, clipFiles: [
            "_ finger gtr",
        ], clipLocations: [
            0,
        ])
        
    ]
}
