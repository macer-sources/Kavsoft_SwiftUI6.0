//
//  ContentView.swift
//  A70.Animated OTP Code TextField
//
//  Created by main on 2025/2/15.
//

import SwiftUI

struct ContentView: View {
    @State private var code: String = ""
    var body: some View {
        VerificationField(type: .six, value: $code) { result in
            if result.count < 6 {
                return .typing
            } else if result == "12345" {
                return .valid
            } else {
                return .invalid
            }
        }
    }
}

#Preview {
    ContentView()
}
