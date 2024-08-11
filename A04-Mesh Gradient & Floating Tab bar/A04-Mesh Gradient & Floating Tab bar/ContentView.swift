//
//  ContentView.swift
//  A04-Mesh Gradient & Floating Tab bar
//
//  Created by Kan Tao on 2024/8/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MeshGradient(width: 3,
                     height: 3,
                     points:[
                        .init(0,0),
                        .init(0.5, 0),
                        .init(1, 0),
                        .init(0, 0.5),
                        .init(0.5, 0.5),
                        .init(1, 0.5),
                        .init(0, 1),
                        .init(0.5, 1),
                        .init(1, 1)
                     ],
                     colors: [
                        .red, .orange,.pink,
                        .pink, .green, .yellow,
                        .indigo, .mint, .cyan
                     ])
        .overlay {
            GeometryReader {
                let size = $0.size
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        CircleView()
                        CircleView()
                        CircleView(true)
                    }
                    HStack(spacing: 0) {
                        CircleView()
                        CircleView()
                        CircleView(true)
                    }
                    .frame(maxHeight: .infinity)
                    
                    HStack(spacing: 0) {
                        CircleView()
                        CircleView()
                        CircleView(true)
                    }
                }
            }
        }
    }
}


extension ContentView {
    @ViewBuilder
    func CircleView(_ isLast: Bool = false ) -> some View {
        Circle()
            .fill(.black)
            .frame(width: 10, height: 10)
        if !isLast {
            Spacer(minLength: 0)
        }
    }
}


#Preview {
    ContentView()
}
