//
//  ContentView.swift
//  A33.Auto Scrolling Infinite Carousel - iOS 18
//
//  Created by Kan Tao on 2024/9/28.
//

import SwiftUI

// smaple model
struct Item: Identifiable {
    var id: String = UUID().uuidString
    var color: Color
}

var mockItems:[Item] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .orange)
]


struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                CustomCarousel {
                    ForEach(mockItems) { item in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(item.color.gradient)
                            .padding(.horizontal, 15)
                    }
                }
                .frame(height: 220)
            }.navigationTitle("Auto scroll carousel")
        }
    }
}

#Preview {
    ContentView()
}
