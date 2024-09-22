//
//  CustomTabBar.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

struct CustomTabBar: View {
    @Environment(TabProperties.self) private var properties
    
    var body: some View {
        @Bindable var binding = properties
        HStack(spacing: 0) {
            ForEach($binding.tabs) { $tab   in
                TabBarButton(tab: $tab)
            }
        }
        .padding(.horizontal, 10)
        .background(.bar)
    }
}

#Preview {
    ContentView()
}


// tab bar button
struct TabBarButton: View {
    @Binding var tab: TabModel
    @Environment(TabProperties.self) private var properties
    
    var body: some View {
        Image(systemName: tab.symbolimage)
            .font(.title2)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .foregroundStyle(properties.activeTab == tab.id ? .primary : properties.editMode ? .primary : .secondary)
            .overlay(content: {
                if !properties.editMode {
                    Rectangle()
                        .foregroundStyle(.clear)
                        .contentShape(.rect)
                        .onTapGesture {
                            properties.activeTab = tab.id
                        }
                }
            })

            .loopingWiggle(properties.editMode)
    }
}
