//
//  ZoomTransitions.swift
//  A01-New in SwiftUI-Xcode 16
//
//  Created by Kan Tao on 2024/8/10.
//

import SwiftUI

struct ZoomTransitions: View {
    @Namespace private var animation
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 3)) {
                    ForEach(sampleItems) { item in
                        NavigationLink(value: item) {
                            GeometryReader {
                                let size = $0.size
                                if let image = item.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: size.width, height: size.height)
                                        .clipShape(.rect(cornerRadius: 20))
                                }
                            }
                            .frame(height: 150)
                        }
                        .contentShape(.rect(cornerRadius: 20))
                        .buttonStyle(.plain)
                    }
                }
                .padding(15)
            }
            .navigationTitle("Home")
            .navigationDestination(for: Item.self) { item in
                GeometryReader {
                    let size = $0.size
                    
                    if let image = item.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(.rect(cornerRadius: 20))
                    }
                }
                .padding(20)
                .navigationTitle(item.title)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    ZoomTransitions()
}

struct Item: Identifiable, Hashable {
    var id = UUID().uuidString
    var title: String
    var image: UIImage?
}


var sampleItems:[Item] = [
    .init(title: "Fanny Hagan 1", image: UIImage.init(named: "pexels_1")),
    .init(title: "Fanny Hagan 2", image: UIImage.init(named: "pexels_2")),
    .init(title: "Fanny Hagan 3", image: UIImage.init(named: "pexels_3")),
    .init(title: "Fanny Hagan 4", image: UIImage.init(named: "pexels_4")),
    .init(title: "Fanny Hagan 5", image: UIImage.init(named: "pexels_5")),
    .init(title: "Fanny Hagan 6", image: UIImage.init(named: "pexels_6")),
    .init(title: "Fanny Hagan 7", image: UIImage.init(named: "pexels_7")),
    
]
