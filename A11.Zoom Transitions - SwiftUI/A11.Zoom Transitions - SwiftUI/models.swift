//
//  models.swift
//  A11.Zoom Transitions - SwiftUI
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct Video: Identifiable {
    let id = UUID().uuidString
    var fileURL: URL
    var thumbnail: UIImage?
}


let files = [
    URL.init(filePath: Bundle.main.path(forResource: "video 1", ofType: "MP4") ?? ""),
    URL.init(filePath: Bundle.main.path(forResource: "video 2", ofType: "MP4") ?? ""),
    URL.init(filePath: Bundle.main.path(forResource: "video 3", ofType: "MP4") ?? ""),
    URL.init(filePath: Bundle.main.path(forResource: "video 4", ofType: "MP4") ?? ""),
    URL.init(filePath: Bundle.main.path(forResource: "video 5", ofType: "MP4") ?? ""),
    URL.init(filePath: Bundle.main.path(forResource: "video 6", ofType: "MP4") ?? ""),
].compactMap({Video(fileURL: $0)})



