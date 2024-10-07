//
//  NativeScrollOffsetReader.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct NativeScrollOffsetReader: View {
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
    @State private var offset: CGFloat = 0
    var body: some View {
        VStack {
            Text("Scroll Offset: \(offset)")
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
//        .onScrollGeometryChange(for: CGFloat.self) { proxy in
//            return proxy.contentOffset.y
//        } action: { oldValue, newValue in
//            offset = newValue
//        }
        .onScrollGeometryChange(for: Bool.self) { proxy in
            return proxy.contentOffset.y >  200
        } action: { oldValue, newValue in
            if newValue {
                print("First Card Moved Away")
            }
        }

    }
}

#Preview {
    NativeScrollOffsetReader()
}
