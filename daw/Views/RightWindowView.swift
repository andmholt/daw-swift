//
//  RightBarView.swift
//  daw
//
//  Created by Andrew Holt on 1/9/23.
//

import SwiftUI

struct RightWindowView: View {
    @EnvironmentObject var gvm: GlobalViewModel
    @StateObject var vm = RightWindowViewModel()
    
    var body: some View {
        GeometryReader { metrics in
            
            HStack(spacing: 0) {
                
                // window
                if gvm.isRightWindowOpen {
                    VStack {
                        
                    }
                    .frame(width: metrics.size.width*(1-(Theme.rightBarWAdj/gvm.rightWindowWAdj)), height: metrics.size.height)
                    .background(.blue)
                }
                
                // bar
                VStack {
                    
                    // file manager
                    VStack {
                        Spacer().frame(height: 0.1*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                        RoundedRectangle(cornerRadius: 7.5)
                            .stroke(.gray.opacity(0.05), lineWidth: 2)
                            .frame(width: 0.8*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width), height: 0.8*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                            .background(.pink)
                        Spacer().frame(height: 0.1*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                        
                        Divider().foregroundColor(.gray.opacity(0.05))
                    }
                    
                    // patch bay
                    VStack {
                        Spacer().frame(height: 0.1*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                        RoundedRectangle(cornerRadius: 7.5)
                            .stroke(.gray.opacity(0.05), lineWidth: 2)
                            .frame(width: 0.8*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width), height: 0.8*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                            .background(.pink)
                        Spacer().frame(height: 0.1*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                        
                        Divider().foregroundColor(.gray.opacity(0.05))
                    }
                    
                    // settings
                    VStack {
                        Spacer().frame(height: 0.1*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                        RoundedRectangle(cornerRadius: 7.5)
                            .stroke(.gray.opacity(0.05), lineWidth: 2)
                            .frame(width: 0.8*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width), height: 0.8*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                            .background(.pink)
                        Spacer().frame(height: 0.1*(gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width))
                        
                        Divider().foregroundColor(.gray.opacity(0.05))
                    }
                }
                .frame(width: gvm.isRightWindowOpen ? metrics.size.width*(Theme.rightBarWAdj/gvm.rightWindowWAdj) : metrics.size.width, height: metrics.size.height, alignment: .top)
                .background(.ultraThinMaterial)
                .onTapGesture {
                    gvm.isRightWindowOpen.toggle()
                }
            }
            .frame(width: metrics.size.width, height: metrics.size.height)
            .background(.gray.opacity(0.05))
        }
    }
}
