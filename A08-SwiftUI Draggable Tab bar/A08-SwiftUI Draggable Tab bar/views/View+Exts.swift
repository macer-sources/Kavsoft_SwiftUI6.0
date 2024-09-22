//
//  View+Exts.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

extension View {
    @ViewBuilder
    func hideTabbar() -> some View {
        self.toolbarVisibility(.hidden, for: .tabBar)
    }
    
    
    @ViewBuilder
    func loopingWiggle(_ isEnabled: Bool = false) -> some View {
        self.symbolEffect(.wiggle.byLayer.counterClockwise, value: isEnabled)
    }
}
