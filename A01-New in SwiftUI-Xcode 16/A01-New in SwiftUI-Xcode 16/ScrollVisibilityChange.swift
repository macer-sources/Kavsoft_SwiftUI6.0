//
//  ScrollVisibilityChange.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI


struct ScrollVisibilityChange: View {
    var colors:[Color] = [
        .red,
        .blue,
        .green,
        .yellow,
        .purple,
        .cyan,
        .brown,
        .black,
        .indigo
    ]
    @State private var isScrolling: Bool = false
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 15) {
                ForEach(colors, id:\.self) {color in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(color)
                        .containerRelativeFrame(.vertical)
                        .onScrollVisibilityChange(threshold: 0.5) { status in
                            if status {
                                print("\(color) is Visiable")
                            }
                        }
                }
            }
            .padding(15)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }
}


#Preview {
    ScrollVisibilityChange()
}
