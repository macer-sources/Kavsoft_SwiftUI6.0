//
//  ContainterValues.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct ContainterValuesPreview: View {
    var body: some View {
        ContainterValuesPreviewCustomView {
            ForEach(0...10, id:\.self) {index in
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                    .containerValue(\.floatIndex, CGFloat(index))
            }
        }
        .padding(15)
    }
}

struct ViewKey: ContainerValueKey {
    static var defaultValue: CGFloat = 0.0
}

extension ContainerValues {
    var floatIndex: CGFloat {
        get {
            self[ViewKey.self]
        }
        set {
            self[ViewKey.self] = newValue
        }
    }
}


struct ContainterValuesPreviewCustomView<Content:View>: View {
    @ViewBuilder var content:Content
    var body: some View {
        VStack(spacing: 0) {
            ForEach(subviews: content) { subview in
                let index = subview.containerValues.floatIndex
                subview
                    .overlay {
                        Text("\(index)")
                    }
            }
        }
    }
}


#Preview {
    ContainterValuesPreview()
}
