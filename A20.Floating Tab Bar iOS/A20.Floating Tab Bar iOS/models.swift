//
//  models.swift
//  A20.Floating Tab Bar iOS
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house"
    case search = "magnifyingglass"
    case notifications = "bell"
    case settings = "gearshape"
}

extension TabModel {
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .search:
            return "Search"
        case .notifications:
            return "Notifications"
        case .settings:
            return "Settings"
        }
    }
}
