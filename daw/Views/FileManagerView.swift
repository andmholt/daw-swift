//
//  FileManagerView.swift
//  daw
//
//  Created by Andrew Holt on 1/9/23.
//

import SwiftUI

struct FileManagerView: View {
    
    @StateObject var vm = FileManagerViewModel()
    
    var body: some View {
        GeometryReader { metrics in
            ScrollView(.vertical) {
                Text("FILE MANAGER VIEW")
            }.frame(width: metrics.size.width, height: metrics.size.height)
        }
    }
}
