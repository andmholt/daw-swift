import SwiftUI

let voxColor: Color = .purple
let synthColor: Color = .pink
let gtrColor: Color = .indigo
let bassColor: Color = .orange
let fxColor: Color = .red
let drumsColor: Color = .blue

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
        PresetTrack(title: "Intro Vox", color: voxColor, clipFiles: [
            "intro vox 0",
        ], clipLocations: [
            3,
        ]),
        PresetTrack(title: "Verse Ld", color: voxColor, clipFiles: [
            "verse ld 0",
        ], clipLocations: [
            3.75,
        ]),
        PresetTrack(title: "Verse Bkgs", color: voxColor, clipFiles: [
            "verse bkgs 0",
            "verse bkgs 1"
        ], clipLocations: [
            11,
            35.75
        ]),
        PresetTrack(title: "Verse Adlibs", color: voxColor, clipFiles: [
            "verse adlibs 0",
            "verse adlibs 1",
            "verse adlibs 2",
        ], clipLocations: [
            13,
            15,
            17.25,
        ]),
        PresetTrack(title: "Pre Vox", color: voxColor, clipFiles: [
            "pre vox 0",
            "pre vox 1",
            "pre vox 2",
            "pre vox 3",
            "pre vox 4",
        ], clipLocations: [
            19,
            31.75,
            35.5,
            39.75,
            43.5
        ]),
        PresetTrack(title: "Drop Vox", color: voxColor, clipFiles: [
            "drop vox 0",
        ], clipLocations: [
            36,
        ]),
        PresetTrack(title: "Drop Adlibs", color: voxColor, clipFiles: [
            "drop adlibs 0",
        ], clipLocations: [
            28,
        ]),
        
        // gtr
        PresetTrack(title: "Finger Guitar", color: gtrColor, clipFiles: [
            "finger gtr 0",
            "finger gtr 1",
        ], clipLocations: [
            0,
            36,
        ]),
        PresetTrack(title: "Mute Pluck", color: gtrColor, clipFiles: [
            "mute pluck 0",
            "mute pluck 1",
            "mute pluck 2",
            "mute pluck 3",
            "mute pluck 4",
            "mute pluck 5",
            "mute pluck 6",
            "mute pluck 7",
            "mute pluck 8",
            "mute pluck 9",
            "mute pluck 10",
            "mute pluck 11",
            "mute pluck 12",
            "mute pluck 13",
        ], clipLocations: [
            0.5,
            2.25,
            4.25,
            6.25,
            8.25,
            10.25,
            12.25,
            14.25,
            16.25,
            18.25,
            28.25,
            32.25,
            36.25,
            40.25
        ]),
        PresetTrack(title: "Verse Line", color: gtrColor, clipFiles: [
            "verse line 0",
        ], clipLocations: [
            4,
        ]),
        PresetTrack(title: "Chopped Chug", color: gtrColor, clipFiles: [
            "chopped chug 0",
        ], clipLocations: [
            12,
        ]),
        PresetTrack(title: "Pre Strum", color: gtrColor, clipFiles: [
            "pre strum 0",
        ], clipLocations: [
            20,
        ]),
        PresetTrack(title: "Chorus Gtr", color: gtrColor, clipFiles: [
            "chorus gtr 0",
        ], clipLocations: [
            28,
        ]),
        
        // synth
        PresetTrack(title: "Synth Keys", color: synthColor, clipFiles: [
            "synth keys 0",
        ], clipLocations: [
            28,
        ]),
        PresetTrack(title: "Synth Lead", color: synthColor, clipFiles: [
            "synth lead 0",
        ], clipLocations: [
            4,
        ]),
        PresetTrack(title: "Synth Pluck", color: synthColor, clipFiles: [
            "synth pluck 0",
            "synth pluck 1",
            "synth pluck 2",
        ], clipLocations: [
            13,
            20.5,
            29,
        ]),
        PresetTrack(title: "Pad", color: synthColor, clipFiles: [
            "pad 0",
        ], clipLocations: [
            4,
        ]),
        PresetTrack(title: "Whistle", color: synthColor, clipFiles: [
            "whistle 0",
            "whistle 1",
            "whistle 2",
            "whistle 3",
            "whistle 4",
            "whistle 5",
            "whistle 6",
            "whistle 7",
            "whistle 8",
        ], clipLocations: [
            0,
            16,
            28,
            30.25,
            32.25,
            34.25,
            36,
            38.25,
            40.25,
            42.25,
        ]),
        
        // bass
        PresetTrack(title: "Bass Gtr", color: bassColor, clipFiles: [
            "bass gtr 0",
        ], clipLocations: [
            20,
        ]),
        PresetTrack(title: "Chopped Bass", color: bassColor, clipFiles: [
            "chopped bass 0",
        ], clipLocations: [
            28,
        ]),
        PresetTrack(title: "Synth Bass", color: bassColor, clipFiles: [
            "synth bass 0",
        ], clipLocations: [
            28,
        ]),
        
        // fx
        PresetTrack(title: "Phone", color: fxColor, clipFiles: [
            "phone 0",
        ], clipLocations: [
            16,
        ]),
        PresetTrack(title: "Heart Monitor", color: fxColor, clipFiles: [
            "heart monitor 0",
        ], clipLocations: [
            42.75,
        ]),
        PresetTrack(title: "Noise", color: fxColor, clipFiles: [
            "noise 0",
        ], clipLocations: [
            0,
        ]),
        PresetTrack(title: "Instr Verb", color: fxColor, clipFiles: [
            "instr verb 0",
        ], clipLocations: [
            0,
        ]),
        PresetTrack(title: "Vox Verb", color: fxColor, clipFiles: [
            "vox verb 0",
        ], clipLocations: [
            19,
        ]),
        
        // drums
        PresetTrack(title: "Kick", color: drumsColor, clipFiles: [
            "kick 0",
            "kick 1",
        ], clipLocations: [
            12,
            28,
        ]),
        PresetTrack(title: "Snare", color: drumsColor, clipFiles: [
            "snare 0",
            "snare 1",
        ], clipLocations: [
            12,
            28,
        ]),
        PresetTrack(title: "Hats", color: drumsColor, clipFiles: [
            "hats 0",
            "hats 1",
        ], clipLocations: [
            12,
            28,
        ]),
        PresetTrack(title: "Percs 1", color: drumsColor, clipFiles: [
            "percs 1 0",
        ], clipLocations: [
            20,
        ]),
        PresetTrack(title: "Percs 2", color: drumsColor, clipFiles: [
            "percs 2 0",
        ], clipLocations: [
            20,
        ]),
        PresetTrack(title: "Percs 3", color: drumsColor, clipFiles: [
            "percs 3 0",
        ], clipLocations: [
            28,
        ]),
        
    ]
}
