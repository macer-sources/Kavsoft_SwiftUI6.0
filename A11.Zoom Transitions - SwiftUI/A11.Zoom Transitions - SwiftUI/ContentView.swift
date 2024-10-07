//
//  ContentView.swift
//  A11.Zoom Transitions - SwiftUI
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct ContentView: View {
    var sharedModel = SharedModel()
    
    var body: some View {
        @Bindable var bindings = sharedModel
        GeometryReader {
            let screenSize = $0.size
            
            NavigationStack {
                VStack(spacing: 0) {
                    HeaderView()
                    ScrollView(.vertical) {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 10), count: 2),spacing: 10) {
                            ForEach($bindings.videos) { $video in
                                CardView(screenSize: screenSize,video: $video)
                                    .environment(sharedModel)
                                    .frame(height: screenSize.height * 0.4)
                            }
                        }
                        .padding(15)
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    func HeaderView() -> some View {
        HStack {
            Button {
                
            } label: {
                Image(systemName: "magnifyingglass")
                    .font(.title3)
            }

            Spacer(minLength: 0)
            
            Button {
                
            } label: {
                Image(systemName: "person.fill")
                    .font(.title3)
            }
        }
        .overlay {
            Text("Stories")
                .font(.title3.bold())
        }
        .foregroundStyle(Color.primary)
        .padding(15)
        .background(.ultraThinMaterial)
    }
}



struct CardView: View {
    var screenSize: CGSize
    @Binding var video: Video
    @Environment(SharedModel.self) private var sharedModel: SharedModel
    var body: some View {
        GeometryReader {
            let size = $0.size
            if let thumbnail = video.thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(.rect(cornerRadius: 15))
            } else {
                RoundedRectangle(cornerRadius: 15)
                    .fill(.fill)
                    .task(priority: .high) {
                        await sharedModel.generateThumbnail($video, size: screenSize)
                    }
            }
            
        }
    }
}


#Preview {
    ContentView()
}
