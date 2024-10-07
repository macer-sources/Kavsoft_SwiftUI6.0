//
//  GestureRepresentable.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct GestureRepresentable: View {
    @State private var offsetY: CGFloat = 0
    var body: some View {
        VStack {
            Text("Translation Y: \(offsetY)")
                .font(.title2.bold())
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(1...50, id:\.self) { _ in
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.red.gradient)
                            .frame(height: 45)
                    }
                }
                .padding(15)
            }
            .gesture(SimultaneousGesture(offset: $offsetY))
        }
    }
}

#Preview {
    GestureRepresentable()
}


struct SimultaneousGesture: UIGestureRecognizerRepresentable {
    @Binding var offset: CGFloat
    func makeUIGestureRecognizer(context: Context) -> some UIGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        gesture.delegate = context.coordinator
        return gesture
    }
    func makeCoordinator(converter: CoordinateSpaceConverter) -> Coordinator {
        return Coordinator()
    }
    func updateUIGestureRecognizer(_ recognizer: UIPanGestureRecognizer, context: Context) {
        
    }
    func handleUIGestureRecognizerAction(_ recognizer: UIPanGestureRecognizer, context: Context) {
        debugPrint("[DEBUG]: TRANSLATION handleUIGestureRecognizerAction")
        let translation = recognizer.translation(in: recognizer.view)
        debugPrint("[DEBUG]: TRANSLATION ")
        offset = translation.y
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            debugPrint("[DEBUG]: shouldRecognizeSimultaneouslyWith")
            return true
        }
    }
    
}

