//
//  ScrollPhaseChange.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct ScrollPhaseChange: View {
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
        VStack {
            Text(isScrolling ? "Scrolling": "Idle")
                .font(.title2.bold())
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(colors, id:\.self) {color in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color)
                            .frame(height: 200)
                    }
                }
                .padding(15)
            }
        }
        .onScrollPhaseChange { oldPhase, newPhase in
            isScrolling = newPhase.isScrolling
        }


    }
}

#Preview {
    ScrollPhaseChange()
}
