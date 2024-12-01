//
//  ContentView.swift
//  A40.App-Wide Overlays | SwiftUI
//
//  Created by Kan Tao on 2024/12/1.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State private var show: Bool = false
    @State private var showSheet: Bool = false
    @State private var text: String  = ""

    var body: some View {
        NavigationStack {
            List {
                TextField("Message", text: $text)
                
                
                Button("Floating Video Player") {
                    show.toggle()
                }
                .universalOverlay(show: $show) {
//                    Circle()
//                        .fill(.red)
//                        .overlay(content: {
//                            Text("\($text)")
//                        })
//                        .frame(width: 50, height: 50)
//                        .onTapGesture {
//                            print("Tapped")
//                        }
                    FloatingVideoPlayer(show: $show)
                }
                
                Button("Show Dummy Sheet") {
                    showSheet.toggle()
                }
            }
            .navigationTitle("Universal Overlay")
        }
        .sheet(isPresented: $showSheet) {
            Text("Hello From Sheets")
        }
    }
}



struct FloatingVideoPlayer: View {
    @Binding var show: Bool
    @State private var player: AVPlayer?
    @State private var offset: CGSize = .zero
    @State private var lastStoreOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            Group {
                if let videoURL {
                    VideoPlayer(player: player)
                        .background(.black)
                        .clipShape(.rect(cornerRadius: 25))
                } else {
                    RoundedRectangle(cornerRadius: 25)
                }
            }
            .frame(height: 250)
            .offset(offset)
            .gesture(DragGesture()
                .onChanged({ value in
                    let translation = value.translation + lastStoreOffset
                    offset = translation
                    
                }).onEnded({ value in
                    withAnimation(.bouncy) {
                        // limiting to not move away from the screen
                        offset.width = 0
                        if offset.height < 0 {
                            offset.height = 0
                        }
                        
                        if offset.height > (size.height - 250) {
                            offset.height = size.height - 250
                        }
                    }
                    
                    lastStoreOffset = offset
                }))
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .padding(.horizontal, 15)
        .transition(.blurReplace)
        .onAppear {
            if let videoURL {
                player = AVPlayer(url: videoURL)
                player?.play()
            }
        }
    }
    
    var videoURL: URL? {
        if let bundle = Bundle.main.path(forResource: "Area", ofType: "mp4") {
            return .init(filePath: bundle)
        }
        return nil
    }
}


extension CGSize {
    static func +(lhs: CGSize, rhs: CGSize) -> CGSize {
        return .init(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
}


#Preview {
    RootView {
        ContentView()
    }
}
