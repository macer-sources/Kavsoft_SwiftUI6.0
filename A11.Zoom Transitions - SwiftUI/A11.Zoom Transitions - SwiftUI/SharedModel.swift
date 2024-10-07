//
//  SharedModel.swift
//  A11.Zoom Transitions - SwiftUI
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI
import AVKit

@Observable
class SharedModel {
    var videos:[Video] = files
    
    
    func generateThumbnail(_ video: Binding<Video>, size: CGSize) async {
        do {
            debugPrint("[DEBUG]:\(video.wrappedValue.fileURL)")
            let assert = AVURLAsset(url: video.wrappedValue.fileURL)
            let generator = AVAssetImageGenerator(asset: assert)
            generator.maximumSize = size
            generator.appliesPreferredTrackTransform = true
            
            let cgimage = try await generator.image(at: .zero).image
            guard let deviceColorBasedImage = cgimage.copy(colorSpace: CGColorSpaceCreateDeviceRGB()) else {
                return
            }
            
            let thumbnail = UIImage(cgImage: deviceColorBasedImage)
            await MainActor.run {
                video.wrappedValue.thumbnail = thumbnail
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
}
