//
//  TracksViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/8/23.
//

import SwiftUI
import AVFoundation

extension TracksView {
    @MainActor class TracksViewModel: ObservableObject {
        // highlight vars
        @Published var startHighlight: CGPoint?
        @Published var currHighlight: CGPoint?
        @Published var topLeftHighlight: CGPoint?
        @Published var bottomLeftHighlight: CGPoint?
        @Published var topRightHighlight: CGPoint?
        @Published var bottomRightHighlight: CGPoint?
        
        // grid
        @Published var gridScale: CGFloat = 11
        
        // cursor
        @Published var cursorLineTop: CGPoint?
        @Published var cursorLineBottom: CGPoint?
        
        // ruler
        @Published var horizontalScrollOffset: CGFloat = 0
        
        // clip drag vars
        @Published var clipDragStartLoc: CGFloat? = nil
        
        // mouse hovering vars
        @Published var hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
        @Published var hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
        
        var getMergeBufId: () -> Int
        var mergeBuf: (AVAudioPCMBuffer, Int) -> Void
        var setPlayPos: (Int) -> Void
        
        // tracks
        //@Published var tracks: [Track] = [AudioTrack(newClip: AudioClip(), location: 30), AudioTrack()]
        @Published var tracks: [TrackViewModel] = []
        
        init(getMergeBufId: @escaping () -> Int, mergeBuf: @escaping (AVAudioPCMBuffer, Int) -> Void, setPlayPos: @escaping (Int) -> Void) {
            self.getMergeBufId = getMergeBufId
            self.mergeBuf = mergeBuf
            self.setPlayPos = setPlayPos
            let setHoveringTrack = { (newHoveringTrack: TrackViewModel, isHovering: Bool) -> Void in
                // if hovering over track, set hoveringTrack to newHoveringTrack
                if isHovering {
                    self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>.allocate(capacity: 1)
                    self.hoveringTrack?.initialize(to: newHoveringTrack)
                }
                // else if not hovering over track and hoveringTrack == newHoveringTrack, deinitialize
                else if !isHovering, newHoveringTrack.track.id == self.hoveringTrack?.pointee.track.id {
                    self.hoveringTrack?.deinitialize(count: 1)
                    self.hoveringTrack?.deallocate()
                    self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
                }
                // else if not hovering over track and hoveringTrack != newHoveringTrack, do nothing
            }
            
            let setHoveringClip = { (newHoveringClip: ClipViewModel, isHovering: Bool) -> Void in
                // if hovering over clip, set hoveringCLip to newHoveringClip
                if isHovering {
                    self.hoveringClip = UnsafeMutablePointer<ClipViewModel>.allocate(capacity: 1)
                    self.hoveringClip?.initialize(to: newHoveringClip)
                }
                // else if not hovering over clip and hoveringClip == newHoveringClip, deinitialize
                else if !isHovering, newHoveringClip.clip.id == self.hoveringClip?.pointee.clip.id {
                    self.hoveringClip?.deinitialize(count: 1)
                    self.hoveringClip?.deallocate()
                    self.hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
                }
                // else if not hovering over clip and hoveringClip != newHoveringClip, do nothing
            }
            
            let deleteTrack = { (id: UUID) -> Void in
                for i in 0..<self.tracks.count {
                    if self.tracks[i].track.id == id {
                        // if pointing to this track, set pointers to nil
                        if self.hoveringTrack?.pointee.track.id == self.tracks[i].track.id {
                            // clip
                            self.hoveringClip?.deinitialize(count: 1)
                            self.hoveringClip?.deallocate()
                            self.hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
                            // track
                            self.hoveringTrack?.deinitialize(count: 1)
                            self.hoveringTrack?.deallocate()
                            self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
                        }
                        self.tracks.remove(at: i)
                        break
                    }
                }
            }
            
            // set preset
            let preset = TalkLikeTest()
//            let preset = MetronomeTest()
            
            for track in preset.tracks {
                print("Loading track \"\(track.title)\"")
                self.tracks.append(AudioTrackViewModel(setHoveringTrack: setHoveringTrack, setHoveringClip: setHoveringClip, deleteTrack: deleteTrack, getMergeBufId: getMergeBufId, mergeBuf: mergeBuf, audioFiles: track.clipFiles, clipLocations: track.clipLocations, tabColor: track.color, title: track.title))
            }
        }
        
        func addTrack() {
            let setHoveringTrack = { (newHoveringTrack: TrackViewModel, isHovering: Bool) -> Void in
                // if hovering over track, set hoveringTrack to newHoveringTrack
                if isHovering {
                    self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>.allocate(capacity: 1)
                    self.hoveringTrack?.initialize(to: newHoveringTrack)
                }
                // else if not hovering over track and hoveringTrack == newHoveringTrack, deinitialize
                else if !isHovering, newHoveringTrack.track.id == self.hoveringTrack?.pointee.track.id {
                    self.hoveringTrack?.deinitialize(count: 1)
                    self.hoveringTrack?.deallocate()
                    self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
                }
                // else if not hovering over track and hoveringTrack != newHoveringTrack, do nothing
            }
            
            let setHoveringClip = { (newHoveringClip: ClipViewModel, isHovering: Bool) -> Void in
                // if hovering over clip, set hoveringCLip to newHoveringClip
                if isHovering {
                    self.hoveringClip = UnsafeMutablePointer<ClipViewModel>.allocate(capacity: 1)
                    self.hoveringClip?.initialize(to: newHoveringClip)
                }
                // else if not hovering over clip and hoveringClip == newHoveringClip, deinitialize
                else if !isHovering, newHoveringClip.clip.id == self.hoveringClip?.pointee.clip.id {
                    self.hoveringClip?.deinitialize(count: 1)
                    self.hoveringClip?.deallocate()
                    self.hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
                }
                // else if not hovering over clip and hoveringClip != newHoveringClip, do nothing
            }
            
            let deleteTrack = { (id: UUID) -> Void in
                for i in 0..<self.tracks.count {
                    if self.tracks[i].track.id == id {
                        // if pointing to this track, set pointers to nil
                        if self.hoveringTrack?.pointee.track.id == self.tracks[i].track.id {
                            // clip
                            self.hoveringClip?.deinitialize(count: 1)
                            self.hoveringClip?.deallocate()
                            self.hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
                            // track
                            self.hoveringTrack?.deinitialize(count: 1)
                            self.hoveringTrack?.deallocate()
                            self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
                        }
                        self.tracks.remove(at: i)
                        break
                    }
                }
            }
            
            self.tracks.append(AudioTrackViewModel(setHoveringTrack: setHoveringTrack, setHoveringClip: setHoveringClip, deleteTrack: deleteTrack, getMergeBufId: getMergeBufId, mergeBuf: mergeBuf, audioFiles: [""], clipLocations: [0], tabColor: .cyan, title: "New Track"))
        }
        
        func deleteTrack(id: UUID) {
            for i in 0..<self.tracks.count {
                if self.tracks[i].track.id == id {
                    // if pointing to this track, set pointers to nil
                    if self.hoveringTrack?.pointee.track.id == self.tracks[i].track.id {
                        // clip
                        self.hoveringClip?.deinitialize(count: 1)
                        self.hoveringClip?.deallocate()
                        self.hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
                        // track
                        self.hoveringTrack?.deinitialize(count: 1)
                        self.hoveringTrack?.deallocate()
                        self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
                    }
                    self.tracks.remove(at: i)
                    break
                }
            }
        }
        
        // * -------------------- *
        // *       GESTURES       *
        // * -------------------- *
        
        func onDragGesture(start: CGPoint?, curr: CGPoint?) {
            // if starting drag or continuing drag
            if let start = start, let curr = curr {
                // if hovering over clip tab or already dragging clip
                if let hoveringTrack = hoveringTrack, hoveringTrack.pointee is ClippableTrackViewModel, let hoveringClip = hoveringClip, hoveringClip.pointee.isHoveringTab || clipDragStartLoc != nil {
                    // drag clip
                    self.dragClip(start: start, curr: curr, hoveringTrack: hoveringTrack, hoveringClip: hoveringClip)
                } else {
                    // highlight
                    self.highlight(start: start, curr: curr)
                }
            }
            // else, drag ended
            else {
                self.highlight(start: start, curr: curr)
            }
        }
        
        func onDragGestureEnded() {
            saveClipBufLoc()
        }
        
        func onTapGesture(_ gesture: CGPoint) {
            
            // reset highlight vars
            self.topLeftHighlight = nil
            self.topRightHighlight = nil
            self.bottomLeftHighlight = nil
            self.bottomRightHighlight = nil
            
            // adjust cursor
            let trackHInt = Int(Theme.trackH)
//            let cursorX = gesture.x
            let cursorLeastX = CGFloat(gesture.x-CGFloat(Int(gesture.x)%11))
            let cursorGreatestX = cursorLeastX + 11
            var cursorX: CGFloat
            if gesture.x - cursorLeastX > cursorGreatestX - gesture.x {
                cursorX = cursorGreatestX
            } else {
                cursorX = cursorLeastX
            }
            let cursorTopY = CGFloat(gesture.y-CGFloat(Int(gesture.y)%trackHInt))
            let cursorBottomY = CGFloat(cursorTopY + Theme.trackH)
            self.cursorLineTop = CGPoint(x: cursorX, y: cursorTopY)
            self.cursorLineBottom = CGPoint(x: cursorX, y: cursorBottomY)
            self.setPlayPos(Int(cursorX/11))
        }
        
        func onMagnificationGesture(_ magnification: CGFloat) {
            //self.gridScale *= magnification
        }
        
        func saveClipBufLoc() {
            if let hoveringTrack {
                let hoveringClippableTrack = UnsafeMutablePointer<AudioTrackViewModel>.allocate(capacity: 1)
                hoveringClippableTrack.initialize(to: hoveringTrack.pointee as! AudioTrackViewModel)
                
                hoveringClippableTrack.pointee.updateBufLocations()
            }
        }
        
        func dragClip(start: CGPoint, curr: CGPoint, hoveringTrack: UnsafeMutablePointer<TrackViewModel>, hoveringClip: UnsafeMutablePointer<ClipViewModel>) {
            // cast pointer
            let hoveringClippableTrack = UnsafeMutablePointer<AudioTrackViewModel>.allocate(capacity: 1)
            hoveringClippableTrack.initialize(to: hoveringTrack.pointee as! AudioTrackViewModel)
            
            // drag clip
            if let clipDragStartLoc = clipDragStartLoc {
                let freeLoc = (clipDragStartLoc * 4 * 11) + (curr.x-start.x)
                let roundedLoc = CGFloat(11 * Int(round(freeLoc / 11)))
                hoveringClippableTrack.pointee.clipLocations[hoveringClip.pointee.clip.id] = roundedLoc/11/4
            } else {
                clipDragStartLoc = hoveringClippableTrack.pointee.clipLocations[hoveringClip.pointee.clip.id]!
                let freeLoc = (hoveringClippableTrack.pointee.clipLocations[hoveringClip.pointee.clip.id]! * 4 * 11) + (curr.x-start.x)
                let roundedLoc = CGFloat(11 * Int(round(freeLoc / 11)))
                hoveringClippableTrack.pointee.clipLocations[hoveringClip.pointee.clip.id] = roundedLoc/11/4
            }
            
            // dealloc
            hoveringClippableTrack.deinitialize(count: 1)
            hoveringClippableTrack.deallocate()
        }
        
        func highlight(start: CGPoint?, curr: CGPoint?) {
            if let start = start, let curr = curr {
                // start/continue highlight
                // calculate correct points by gridFreq
                let gridFreqFloat = CGFloat(Theme.gridFreq)
                let trackHInt = Int(Theme.trackH)
                
                let startX = start.x+(gridFreqFloat-CGFloat(Int(start.x)%Theme.gridFreq))
                let startY = CGFloat(start.y-CGFloat(Int(start.y)%trackHInt))
                
                let currX = curr.x+(gridFreqFloat-CGFloat(Int(curr.x)%Theme.gridFreq))
                let currY = CGFloat(curr.y-CGFloat(Int(curr.y)%trackHInt))
                
                self.topLeftHighlight = CGPoint(x: startX, y: startY<currY ? startY : currY)
                self.bottomLeftHighlight = CGPoint(x: startX, y: startY>currY ? startY+Theme.trackH : currY+Theme.trackH)
                self.topRightHighlight = CGPoint(x: currX, y: startY<currY ? startY : currY)
                self.bottomRightHighlight = CGPoint(x: currX, y: startY>currY ? startY+Theme.trackH : currY+Theme.trackH)
            } else {
                // end highlight
                self.topLeftHighlight = nil
                self.bottomLeftHighlight = nil
                self.topRightHighlight = nil
                self.bottomRightHighlight = nil
            }
        }
        
        func setHoveringTrack(newHoveringTrack: TrackViewModel?) {
            if let newHoveringTrack = newHoveringTrack {
                self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>.allocate(capacity: 1)
                self.hoveringTrack?.initialize(to: newHoveringTrack)
            } else {
                self.hoveringTrack?.deinitialize(count: 1)
                self.hoveringTrack?.deallocate()
                self.hoveringTrack = UnsafeMutablePointer<TrackViewModel>(nil)
            }
        }
        
        func setHoveringClip(newHoveringClip: ClipViewModel?) {
            if let newHoveringClip = newHoveringClip {
                self.hoveringClip = UnsafeMutablePointer<ClipViewModel>.allocate(capacity: 1)
                self.hoveringClip?.initialize(to: newHoveringClip)
            } else {
                self.hoveringClip?.deinitialize(count: 1)
                self.hoveringClip?.deallocate()
                self.hoveringClip = UnsafeMutablePointer<ClipViewModel>(nil)
            }
        }
        
    }
}
