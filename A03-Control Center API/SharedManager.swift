//
//  SharedManager.swift
//  A03-Control Center API
//
//  Created by Kan Tao on 2024/8/11.
//

import Foundation

class SharedManager {
    static let shared = SharedManager()
    // control toggle
    var isTurnedOn: Bool = false
    // control button
    var caffineInTake: CGFloat = 0
}
