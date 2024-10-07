//
//  DetailView.swift
//  A11.Zoom Transitions - SwiftUI
//
//  Created by Kan Tao on 2024/10/7.
//

import SwiftUI

struct DetailView: View {
    var video: Video
    var animation: Namespace.ID
    @Environment(SharedModel.self) private var sharedModel
    
    @State private var hidesThumbnail: Bool = false
    @State private var scrollUUID: UUID?
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Color.black
            
            ScrollView(.vertical) {
                LazyVStack(spacing: 0) {
                    ForEach(sharedModel.videos) { video in
                        if let thumbnail = video.thumbnail {
                            Image(uiImage: thumbnail)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(.rect(cornerRadius: 15))
                        }
                    }
                }
            }
            .scrollPosition(id: $scrollUUID)
            .scrollTargetBehavior(.paging)
            .scrollIndicators(.hidden)
            .zIndex(hidesThumbnail ? 1 : 0)
            
            if let thumbnail = video.thumbnail, !hidesThumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
                    .task {
                        scrollUUID = video.id
                        try? await Task.sleep(for: .seconds(0.15))
                        hidesThumbnail = true
                    }
            }
        }
        .ignoresSafeArea()
        .navigationTransition(.zoom(sourceID: hidesThumbnail ? scrollUUID ?? video.id : video.id, in: animation))
    }
}

#Preview {
    ContentView()
}
