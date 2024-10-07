//
//  ContentView.swift
//  A04-Mesh Gradient & Floating Tab bar
//
//  Created by Kan Tao on 2024/8/11.
//

import SwiftUI

struct ContentView: View {
    @State private var top: [MeshPoint] = [
        .init(x: 0, y: 0),
        .init(x: 0.5, y: 0),
        .init(x: 1, y: 0),
        
    ]
    @State private var center:[MeshPoint] = [
        .init(x: 0, y: 0.5),
        .init(x: 0.5, y: 0.5),
        .init(x: 1, y: 0.5),
    ]
    @State private var bottom:[MeshPoint] = [
        .init(x: 0, y: 1),
        .init(x: 0.5, y: 1),
        .init(x: 1, y: 1)
    ]
    
    var body: some View {
        MeshGradient(width: 3,
                     height: 3,
                     points:[
                        .p(top[0]),.p(top[1]),.p(top[2]),
                        .p(center[0]),.p(center[1]),.p(center[2]),
                        .p(bottom[0]),.p(bottom[1]),.p(bottom[2]),
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
                        CircleView($top[0], size)
                        CircleView($top[1], size)
                        CircleView($top[2], size, true)
                    }
                    HStack(spacing: 0) {
                        CircleView($center[0], size)
                        CircleView($center[1], size)
                        CircleView($center[2], size, true)
                    }
                    .frame(maxHeight: .infinity)
                    
                    HStack(spacing: 0) {
                        CircleView($bottom[0], size)
                        CircleView($bottom[1], size)
                        CircleView($bottom[2], size, true)
                    }
                }
            }
        }
        .coordinateSpace(.named("MESH"))
    }
}

struct MeshPoint {
    var x: Float
    var y: Float
    
    init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    var offset: CGSize = .zero
    var lastOffset: CGSize = .zero
}

extension SIMD2<Float> {
    static func p(_ point: MeshPoint) ->Self {
        return .init(point.x, point.y)
    }
}


extension ContentView {
    @ViewBuilder
    func CircleView(_ point:Binding<MeshPoint>, _ size: CGSize,  _ isLast: Bool = false ) -> some View {
        Circle()
            .fill(.black)
            .frame(width: 10, height: 10)
            .contentShape(.rect)
            .offset(point.wrappedValue.offset)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named("MESH"))
                    .onChanged({ value in
                        let localtion = value.location
                        let x = Float(localtion.x / size.width)
                        let y = Float(localtion.y / size.height)
                        
                        point.wrappedValue.x = x
                        point.wrappedValue.y = y
                        
                        let offset = value.translation
                        let lastOffset = point.wrappedValue.lastOffset
                        
                        point.wrappedValue.offset = offset + lastOffset
                    })
                    .onEnded({ value in
                        point.wrappedValue.lastOffset = point.wrappedValue.offset
                    })
                
            )
        if !isLast {
            Spacer(minLength: 0)
        }
    }
}


extension CGSize {
    static func +(lhs:CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}

#Preview {
    ContentView()
}
