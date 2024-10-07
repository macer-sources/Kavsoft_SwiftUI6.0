//
//  FloatingTabBar.swift
//  A04-Mesh Gradient & Floating Tab bar
//
//  Created by Kan Tao on 2024/8/11.
//

import SwiftUI

struct FloatingTabBar: View {
    var body: some View {
        TabView {
            Tab.init("Home", image: "house.fill") {
                
            }
            Tab.init("Search", image: "magnifyingglass", role: .search) {
                
            }
            Tab.init("Notification", image: "bell.fill") {
                
            }
            Tab.init("Settings", image: "gearshape") {
                
            }
        }
//        .tabViewStyle(.tabBarOnly)
//        .tabViewStyle(.sidebarAdaptable)
    }
}

#Preview {
    FloatingTabBar()
}
