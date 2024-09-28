//
//  CustomCarousel.swift
//  A33.Auto Scrolling Infinite Carousel - iOS 18
//
//  Created by Kan Tao on 2024/9/28.
//

import SwiftUI

struct CustomCarousel<Content:View>: View {
    @Binding var activeIndex: Int
    @ViewBuilder var content: Content
    
    // View properties
    @State private var scrollPosition: Int?
    @State private var isScrolling:Bool = false
    @GestureState private var isHoldingScreen: Bool = false
    @State private var timer = Timer.publish(every: autoScrollDuration, on: .main, in: .default).autoconnect()
    
    @State private var offsetBasePosition: Int = 0
    @State private var isSettled: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            Group(subviews: content) { collection in
                ScrollView(.horizontal) {
                    // 确保使用HStack而不是LazyHStack，因为LazyHStack会在视图移动到可视屏幕区域之外时移除视图，从而使scrollPosition无法自动滚动到特定位置。
                    HStack(spacing: 0) {
                        
                            if let lastItem = collection.last {
                                lastItem.frame(width: size.width, height: size.height)
                                    .id(-1)
                            }
                            ForEach(collection.indices, id:\.self) { index in
                                collection[index]
                                    .frame(width: size.width, height: size.height)
                                    .id(index)
                            }
                            
                            if let firstItem = collection.first {
                                firstItem.frame(width: size.width, height: size.height)
                                    .id(collection.count)
                            }
                            

                    }
                    .scrollTargetLayout() // TODO: 必须加这一句
                }
                .scrollPosition(id: $scrollPosition)
                .scrollIndicators(.hidden)
                .scrollTargetBehavior(.paging)
                // 从iOS 18开始，synchronousgesture将与滚动视图同时工作。
                .simultaneousGesture(DragGesture(minimumDistance: 0).updating($isHoldingScreen, body: { _, out, _ in
                    out = true
                }))
                .onChange(of: isHoldingScreen, { oldValue, newValue in
                    if newValue {
                        timer.upstream.connect().cancel()
                    }else {
                        if isSettled && scrollPosition != offsetBasePosition {
                            scrollPosition = offsetBasePosition
                        }
                        
                        timer = Timer.publish(every: Self.autoScrollDuration, on: .main, in: .default).autoconnect()
                    }
                })
                .onReceive(timer, perform: { _ in
                    // safe check
                    guard !isHoldingScreen && !isScrolling else {return}
                    let nextIndex = (scrollPosition ?? 0) + 1
                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                        scrollPosition = (nextIndex == collection.count + 1) ? 0 : nextIndex
                        
                    }
                })

                .onScrollPhaseChange { oldPhase, newPhase in
                    isScrolling = newPhase.isScrolling
                    
                    if !isScrolling,scrollPosition == -1 {
                        scrollPosition = collection.count - 1
                    }
                    
                    if !isScrolling,scrollPosition == collection.count && !isHoldingScreen {
                        scrollPosition = 0
                    }
                }
                .onChange(of: scrollPosition) { oldValue, newValue in
                    if let newValue {
                        if newValue == -1 {
                            activeIndex = collection.count - 1
                        }else if newValue == collection.count {
                            activeIndex = 0
                        } else {
                            activeIndex = max(min(newValue, collection.count - 1), 0)
                        }
                    }
                }
                .onScrollGeometryChange(for: CGFloat.self) {
                    $0.contentOffset.x
                } action: { oldValue, newValue in
                    isSettled = size.width > 0 ? (Int(newValue) % Int(size.width) == 0) : false
                    let index = size.width > 0 ? Int((newValue / size.width).rounded() - 1) : 0
                    offsetBasePosition = index
                    
                    if isSettled && (scrollPosition != index || index == collection.count) && !isScrolling && !isHoldingScreen {
                        scrollPosition = index == collection.count ? 0 : index
                    }
                    
                }

            }
            .onAppear {
                scrollPosition = 0
            }
        }
    }
    
    
    static var autoScrollDuration: CGFloat {
        return 1.0
    }
    
}

#Preview {
    ContentView()
}
