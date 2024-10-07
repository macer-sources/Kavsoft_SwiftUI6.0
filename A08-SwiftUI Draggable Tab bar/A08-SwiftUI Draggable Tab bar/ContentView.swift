//
//  ContentView.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

struct ContentView: View {
    var properties: TabProperties = .init()
    
    var body: some View {
        @Bindable var bindings = properties
        VStack(spacing: 0) {
            TabView(selection: $bindings.activeTab) {
                Tab.init(value: 0) {
                    Home()
                        .environment(properties)
                        .hideTabbar()
                }
                Tab.init(value: 1) {
                    Text("Search")
                        .hideTabbar()
                }
                Tab.init(value: 2) {
                    Text("Notifications")
                        .hideTabbar()
                }
                Tab.init(value: 3) {
                    Text("Community")
                        .hideTabbar()
                }
                Tab.init(value: 4) {
                    Text("Setting")
                        .hideTabbar()
                }
            }
            
            CustomTabBar()
                .environment(properties)
        }
    }
}

#Preview {
    ContentView()
}
