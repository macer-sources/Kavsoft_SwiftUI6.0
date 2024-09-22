//
//  CustomGesture.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

struct CustomGesture: UIGestureRecognizerRepresentable {
    @Binding var isEnabled: Bool
    // only receives start and end updates
    var trigger: (Bool) -> Void
    var onChanged:(CGSize, CGPoint) -> Void
    func makeUIGestureRecognizer(context: Context) -> UIPanGestureRecognizer {
        let gesture = UIPanGestureRecognizer()
        return gesture
    }
    func updateUIGestureRecognizer(_ recognizer: UIGestureRecognizerType, context: Context) {
        recognizer.isEnabled = isEnabled
    }
    func handleUIGestureRecognizerAction(_ recognizer: UIGestureRecognizerType, context: Context) {
        let view = recognizer.view
        let location = recognizer.location(in: view)
        let translation = recognizer.translation(in: view)
        
        let offset = CGSize.init(width: translation.x, height: translation.y)
        
        switch recognizer.state {
        case .began:
            trigger(true)
        case .ended,.cancelled:
            trigger(false)
        default:
            onChanged(offset, location)
        }
    }
}
