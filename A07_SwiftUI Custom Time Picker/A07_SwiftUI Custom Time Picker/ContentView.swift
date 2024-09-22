//
//  ContentView.swift
//  A07_SwiftUI Custom Time Picker
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

struct ContentView: View {
    @State private var hours: Int = 0
    @State private var minutes: Int = 30
    @State private var seconds: Int = 25
    
    var body: some View {
        NavigationStack {
            VStack {
                TimePicker(hour: $hours, minutes: $minutes, seconds: $seconds)
                    .padding(15)
                    .background(.white, in: .rect(cornerRadius: 10))
                    .padding(.horizontal, 20)
            }
            .padding(15)
            .navigationTitle("Custom Time Picker")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.15))
        }
    }
}

#Preview {
    ContentView()
}
