//
//  Home.swift
//  A08-SwiftUI Draggable Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

struct Home: View {
    @Environment(TabProperties.self) private var properties
    
    var body: some View {
        @Bindable var bindings = properties
        NavigationStack {
            List {
                Toggle("Edit tab locations", isOn: $bindings.editMode)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    ContentView()
}
