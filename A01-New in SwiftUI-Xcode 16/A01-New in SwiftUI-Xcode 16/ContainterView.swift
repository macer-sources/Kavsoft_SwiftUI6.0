//
//  ContainterView.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct ContainterView: View {
    var body: some View {
        CustomView(content: {
            ForEach(0...10, id:\.self) { index in
                RoundedRectangle(cornerRadius: 15)
                    .fill(.red.gradient)
                    .frame(height: 45)
            }
        })
        .padding(15)
    }
}

struct CustomView<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 10) {
//            Group(sections: <#T##View#>, transform: <#T##(SectionCollection) -> View#>)
            Group(subviews: content) { collection in
                ForEach(collection) { subview in
                    let index = collection.firstIndex(where: {$0.id == subview.id})
                    subview
                        .overlay {
                            if let index {
                                Text("\(index)")
                                    .font(.largeTitle.bold())
                            }
                        }
                }
            }
        }
    }
}



#Preview {
    ContainterView()
}
