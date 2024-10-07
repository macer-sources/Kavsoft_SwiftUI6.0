//
//  PopView.swift
//  A25. SwiftUI Alert Dialogs
//
//  Created by Kan Tao on 2024/9/24.
//

import SwiftUI


struct Config {
    var backgroundColor: Color = .black.opacity(0.25)
    // you can add extra properties here if you wish to
    
    
}


extension View {
    @ViewBuilder
    func popView<Content: View>(
        config: Config = .init(),
        isPreseted: Binding<Bool>,
        onDismiss:@escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(PopViewHelper(config: config, isPresented: isPreseted, onDismiss: onDismiss, viewContent: content))
    }
}


fileprivate struct PopViewHelper<ViewContent: View>: ViewModifier {
    var config: Config
    @Binding var isPresented: Bool
    var onDismiss:() -> Void
    @ViewBuilder var viewContent: ViewContent
    
    @State private var presentFullScreenCover: Bool = false
    @State private var animateView: Bool = false
    func body(content: Content) -> some View {
        
        let screenHeight = screenSize.height
        let animateView = animateView
        
        // TODO: presentFullScreenCover 此值更改是没有动画效果的
        content
            .fullScreenCover(isPresented: $presentFullScreenCover, onDismiss: onDismiss, content: {
                ZStack(content: {
                    
                    Rectangle()
                        .fill(config.backgroundColor)
                        .ignoresSafeArea()
                        .opacity(animateView ? 1 : 0)
                    
                    viewContent
                        .visualEffect { content, geometryProxy in
                            content
                                .offset(y: offset(geometryProxy,screenHeight: screenHeight, animateView: animateView))
                        }
                        .presentationBackground(Color.clear)
                        .task {
                            guard !animateView else {return}
                            withAnimation(.bouncy(duration: 0.4, extraBounce: 0.05)) {
                                self.animateView = true
                            }
                        }
                        .ignoresSafeArea(.container, edges: .all)
                    
                })
            })
            .onChange(of: isPresented) { oldValue, newValue in
                if newValue {
                    toggleView(true)
                }else {
                    Task {
                        withAnimation(.snappy(duration: 0.45, extraBounce: 0)) {
                            self.animateView = false
                        }
                        try? await Task.sleep(for: .seconds(0.45))
                        
                        toggleView(false)
                    }
                }
            }
    }
    
    
    // TODO: 关闭动画
    private func toggleView(_ status: Bool) {
        var transaction = Transaction()
        transaction.disablesAnimations = true
        withTransaction(transaction) {
            presentFullScreenCover = status
        }
    }
    
    private nonisolated func offset(_ proxy: GeometryProxy, screenHeight: CGFloat, animateView: Bool) -> CGFloat {
        let viewHeight = proxy.size.height
        return animateView ? 0 : (screenHeight + viewHeight) / 2
    }
    
    var screenSize: CGSize {
        if let screenSize = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.screen.bounds.size {
            return screenSize
        }
        return .zero
    }
    
}

#Preview {
    ContentView()
}
