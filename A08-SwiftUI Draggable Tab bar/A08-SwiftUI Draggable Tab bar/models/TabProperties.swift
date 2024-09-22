//
//  TabProperties.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import Foundation


@Observable
class TabProperties {
    // shared tab properties
    
    var activeTab: Int = 0
    var editMode: Bool = false
    var tabs:[TabModel] = defaultOrderTabs
    
}
