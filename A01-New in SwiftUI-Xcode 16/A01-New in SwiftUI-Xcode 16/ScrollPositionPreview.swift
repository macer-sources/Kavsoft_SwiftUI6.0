//
//  ScrollPosition.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct ScrollPositionPreview: View {
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
    @State private var position: ScrollPosition = .init(idType: Color.self)
    var body: some View {
        VStack {
            Button("Move") {
                withAnimation {
                    position.scrollTo(y: 250)
                }

            }
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(colors, id:\.self) {color in
                        RoundedRectangle(cornerRadius: 20)
                            .fill(color)
                            .frame(height: 200)
                    }
                }
                .padding(15)
                .scrollTargetLayout()
            }
            .scrollPosition($position)
        }



    }
}

#Preview {
    ScrollPositionPreview()
}
