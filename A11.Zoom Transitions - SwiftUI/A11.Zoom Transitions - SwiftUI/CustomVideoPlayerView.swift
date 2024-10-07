//
//  CustomVideoPlayerView.swift
//  A11.Zoom Transitions - SwiftUI
//
//  Created by Kan Tao on 2024/10/7.
//

import SwiftUI
import AVKit

struct CustomVideoPlayerView: UIViewControllerRepresentable {
    @Binding var player: AVPlayer?
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        controller.videoGravity = .resizeAspectFill
        return controller
    }
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        uiViewController.player = player
    }
}


struct VideoPlayerView: View {
    var video: Video
    @State private var player: AVPlayer?
    var body: some View {
        CustomVideoPlayerView(player: $player)
            .onAppear(perform: {
                guard player == nil else {return}
                player = AVPlayer(url: video.fileURL)
            })
            .onDisappear(perform: {
                player?.pause()
            })
            .onScrollVisibilityChange { isVisiable in
                if isVisiable {
                    player?.play()
                } else {
                    player?.pause()
                }
            }
            .onGeometryChange(for: Bool.self) { proxy in
                let minY = proxy.frame(in: .scrollView(axis: .vertical)).minY
                let height = proxy.size.height * 0.97
                return -minY > height || minY > height
            } action: { newValue in
                if newValue {
                    player?.seek(to: .zero)
                }
            }

    }
}
