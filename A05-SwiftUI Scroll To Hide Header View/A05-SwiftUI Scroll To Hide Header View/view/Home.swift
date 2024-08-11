//
//  Home.swift
//  A05-SwiftUI Scroll To Hide Header View
//
//  Created by Kan Tao on 2024/8/11.
//

import SwiftUI

struct Home: View {
    @State private var naturalScrollOffset: CGFloat = 0
    var body: some View {
        GeometryReader { proxy in
            let safeArea = proxy.safeAreaInsets
            let headerHeight = 60 + safeArea.top
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(1...50, id:\.self) { _ in
                        DummyView()
                    }
                }
                .padding(15)
            }
            .safeAreaInset(edge: .top, spacing: 0, content: {
                HeaderView()
                    .padding(.bottom, 15)
                    .frame(height: headerHeight, alignment: .bottom)
                    .background(.background)
            })
            .onScrollGeometryChange(for: CGFloat.self) { proxy in
                proxy.contentOffset.y
            } action: { oldValue, newValue in
                naturalScrollOffset = newValue
            }
            .ignoresSafeArea(.container, edges: .top)
        }

    }
}


extension Home {
    @ViewBuilder
    private func HeaderView() -> some View {
        HStack(spacing: 20, content: {
            Circle()
                .fill(.yellow)
                .frame(width: 30, height: 30)
            Spacer()
            
            Button("", systemImage: "airplayvideo") {
                
            }
            Button("", systemImage: "bell") {
                
            }
            Button("", systemImage: "magnifyingglass") {
                
            }
        })
        .font(.title2)
        .foregroundStyle(.primary)
        .padding(.horizontal, 15)
    }
}


extension Home {
    @ViewBuilder
    private func DummyView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: 6)
                .frame(height: 220)
            
            HStack(spacing: 10) {
                Circle()
                    .frame(width: 45, height: 45)
                
                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .frame(height: 10)
                    
                    HStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 100)
                        Rectangle()
                            .frame(width: 80)
                        Rectangle()
                            .frame(width: 60)
                    }
                    .frame(height: 10)
                }
            }
        }
        .foregroundStyle(.tertiary)
    }
}





#Preview {
    Home()
        .preferredColorScheme(.dark)
}
