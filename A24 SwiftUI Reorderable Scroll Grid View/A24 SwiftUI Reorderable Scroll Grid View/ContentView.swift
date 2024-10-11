//
//  ContentView.swift
//  A24 SwiftUI Reorderable Scroll Grid View
//
//  Created by Kan Tao on 2024/10/11.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader(content: { geometry in
            let safeArea = geometry.safeAreaInsets
            
            Image(.wallpaper)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .blur(radius: 40, opaque: true)
                .overlay(content: {
                    Rectangle()
                        .fill(.black.opacity(0.1))
                })
                .ignoresSafeArea()
            
            Home(safeArea: safeArea)
        })
    }
}

#Preview {
    ContentView()
}
