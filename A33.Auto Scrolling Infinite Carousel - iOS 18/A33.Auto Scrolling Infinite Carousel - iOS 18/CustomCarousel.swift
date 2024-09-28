//
//  CustomCarousel.swift
//  A33.Auto Scrolling Infinite Carousel - iOS 18
//
//  Created by Kan Tao on 2024/9/28.
//

import SwiftUI

struct CustomCarousel<Content:View>: View {
    @ViewBuilder var content: Content
    
    // View properties
    @State private var scrollPosition: Int?
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                // 确保使用HStack而不是LazyHStack，因为LazyHStack会在视图移动到可视屏幕区域之外时移除视图，从而使scrollPosition无法自动滚动到特定位置。
                HStack(spacing: 0) {
                    Group(subviews: content) { collection in
                        ForEach(collection.indices, id:\.self) { index in
                            collection[index]
                                .frame(width: size.width, height: size.height)
                                .id(index)
                        }
                    }
                }
            }
            .scrollPosition(id: $scrollPosition)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
        }
    }
}

#Preview {
    ContentView()
}
