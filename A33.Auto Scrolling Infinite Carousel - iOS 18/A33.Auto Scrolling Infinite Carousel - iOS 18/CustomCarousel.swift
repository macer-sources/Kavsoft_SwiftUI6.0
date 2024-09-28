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
    @State private var isScrolling:Bool = false
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            ScrollView(.horizontal) {
                // 确保使用HStack而不是LazyHStack，因为LazyHStack会在视图移动到可视屏幕区域之外时移除视图，从而使scrollPosition无法自动滚动到特定位置。
                HStack(spacing: 0) {
                    Group(subviews: content) { collection in
                        if let lastItem = collection.last {
                            lastItem.frame(width: size.width, height: size.height)
                                .id(-1)
                                .onChange(of: isScrolling) { oldValue, newValue in
                                    if !newValue,scrollPosition == -1 {
                                        scrollPosition = collection.count - 1
                                    }
                                }
                        }
                        ForEach(collection.indices, id:\.self) { index in
                            collection[index]
                                .frame(width: size.width, height: size.height)
                                .id(index)
                        }
                        
                        if let firstItem = collection.first {
                            firstItem.frame(width: size.width, height: size.height)
                                .id(collection.count)
                                .onChange(of: isScrolling) { oldValue, newValue in
                                    if !newValue,scrollPosition == collection.count {
                                        scrollPosition = 0
                                    }
                                }
                        }
                        
                    }
                }
                .scrollTargetLayout() // TODO: 必须加这一句
            }
            .scrollPosition(id: $scrollPosition)
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            .onAppear {
                scrollPosition = 0
            }
            .onScrollPhaseChange { oldPhase, newPhase in
                isScrolling = newPhase.isScrolling
            }
        }
    }
}

#Preview {
    ContentView()
}
