//
//  GlobalViewModel.swift
//  daw
//
//  Created by Andrew Holt on 1/20/23.
//

import SwiftUI

class GlobalViewModel: ObservableObject {
    @Published var rightWindowWAdj: CGFloat = 0.25
    @Published var isRightWindowOpen: Bool = false
}
