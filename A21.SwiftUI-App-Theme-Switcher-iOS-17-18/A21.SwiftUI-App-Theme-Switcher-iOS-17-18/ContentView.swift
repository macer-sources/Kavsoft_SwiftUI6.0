//
//  ContentView.swift
//  A21.SwiftUI-App-Theme-Switcher-iOS-17-18
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("ThemeScheme") private var themeScheme: ThemeScheme = .device
    @SceneStorage("ShowScenePickerView") private var showPickerView: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(1...40, id:\.self) { index in
                    Text("Chat History \(index)")
                }
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPickerView.toggle()
                    } label: {
                        Image(systemName: "moon.fill")
                            .foregroundStyle(Color.primary)
                    }

                }
            }
        }
        .animation(.easeInOut(duration: 0.25), value: themeScheme)
    }
}

#Preview {
    ContentView()
}
