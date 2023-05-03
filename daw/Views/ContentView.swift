//
//  ContentView.swift
//  daw
//
//  Created by Andrew Holt on 12/29/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var gvm = GlobalViewModel()
    @StateObject var vm = ContentViewModel()
    
    let TOOLBAR_HEIGHT_ADJ: CGFloat = 0.05
    let SPACER_HEIGHT_ADJ: CGFloat = 0.025
    
    var body: some View {
        GeometryReader { metrics in
            ZStack {
                HStack(spacing: 0) {
                    VStack(spacing: 0) {
                        // toolbar
                        ToolbarView(vm: ToolbarViewModel(play: vm.play, stop: vm.stop ))
                            .frame(width: (metrics.size.width*CGFloat(1-(gvm.isRightWindowOpen ? gvm.rightWindowWAdj+Theme.rightBarWAdj : Theme.rightBarWAdj)))-(Theme.outsidePadding*2), height: metrics.size.height*TOOLBAR_HEIGHT_ADJ)
                        // under toolbar
                        HStack(spacing: 0) {
                            //HSplitView {
                            HStack(spacing: 0) {
                                // main window for tracks
                                TracksView(getMergeBufId: vm.getMergeBufId, mergeBuf: vm.mergeBuf, playheadPos: $vm.playheadPos, setPlayPos: vm.setPlayPos)
                                    .frame(width: (metrics.size.width*CGFloat(1-(gvm.isRightWindowOpen ? gvm.rightWindowWAdj+Theme.rightBarWAdj : Theme.rightBarWAdj)))-(Theme.outsidePadding*2), height: (metrics.size.height*CGFloat(1-TOOLBAR_HEIGHT_ADJ))-(Theme.outsidePadding*2))
                                // file manager
                                /*FileManagerView()
                                    .frame(width: metrics.size.width*CGFloat(0.25), height: metrics.size.height*CGFloat(1-TOOLBAR_HEIGHT_ADJ-(SPACER_HEIGHT_ADJ*2)))*/
                            }
                            .frame(width: (metrics.size.width*CGFloat(1-(gvm.isRightWindowOpen ? gvm.rightWindowWAdj+Theme.rightBarWAdj : Theme.rightBarWAdj)))-(Theme.outsidePadding*2), height: (metrics.size.height*CGFloat(1-TOOLBAR_HEIGHT_ADJ))-(Theme.outsidePadding*2))
                            .background(.ultraThinMaterial)
                        }
                        .frame(width: (metrics.size.width*CGFloat(1-(gvm.isRightWindowOpen ? gvm.rightWindowWAdj+Theme.rightBarWAdj : Theme.rightBarWAdj)))-(Theme.outsidePadding*2), height: (metrics.size.height*CGFloat(1-TOOLBAR_HEIGHT_ADJ))-(Theme.outsidePadding*2))
                    }
                    .frame(width: (metrics.size.width*CGFloat(1-(gvm.isRightWindowOpen ? gvm.rightWindowWAdj+Theme.rightBarWAdj : Theme.rightBarWAdj)))-(Theme.outsidePadding*2), height: metrics.size.height-(Theme.outsidePadding*2))
                    .padding(Theme.outsidePadding)
                    
                    // right window
                    RightWindowView()
                        .environmentObject(gvm)
                        .frame(width: metrics.size.width*(gvm.isRightWindowOpen ? gvm.rightWindowWAdj+Theme.rightBarWAdj : Theme.rightBarWAdj), height: metrics.size.height)
                }
                .frame(width: metrics.size.width, height: metrics.size.height)
            }
            .frame(width: metrics.size.width, height: metrics.size.height)
            .background(.black)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
