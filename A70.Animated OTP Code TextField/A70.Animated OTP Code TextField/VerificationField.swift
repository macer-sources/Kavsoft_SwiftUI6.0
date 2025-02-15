//
//  VerificationField.swift
//  A70.Animated OTP Code TextField
//
//  Created by main on 2025/2/15.
//

import SwiftUI


enum CodeType: Int, CaseIterable {
    case four = 4
    case six = 6
    
    var stringValue: String {
        "\(rawValue) Digit"
    }
}

enum TypingState {
    case typing
    case valid
    case invalid
}

enum TextFieldStyle: String, CaseIterable {
    case roundedBorder = "Rounded Border"
    case underlined = "Underlined"
}





struct VerificationField: View {
    var type: CodeType
    var style: TextFieldStyle = .roundedBorder
    @Binding var value: String
    // we can use this to validate the typed code!
    var onChange:(String)async -> TypingState
    // view properties
    @State private var state: TypingState = .typing
    @FocusState private var isActive: Bool
    @State private var invalidTrigger: Bool = false
    var body: some View {
        HStack(spacing: style == .roundedBorder ? 6 : 10) {
            ForEach(0..<type.rawValue, id:\.self) {index in
                CharacterView(index)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: value)
        .animation(.easeInOut(duration: 0.2), value: isActive)
        .compositingGroup()
        // invilid phase animator
        .phaseAnimator([0,10,-10,-5,5,0], trigger: invalidTrigger, content: { content, offset in
            content.offset(x: offset)
        }, animation: { _ in
                .linear(duration: 0.06)
        })
        .background {
            TextField("", text: $value)
                .focused($isActive)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .mask(alignment: .trailing) {
                    Rectangle()
                        .frame(width: 1, height: 1)
                        .opacity(0.01)
                }
                .allowsHitTesting(true)
        }
        .contentShape(.rect)
        .onTapGesture {
            isActive = true
        }
        .onChange(of: value) { oldValue, newValue in
            // limiting text length
            value = String(newValue.prefix(type.rawValue))
            Task { @MainActor in
                // for validation check
                state = await onChange(value)
                if state == .invalid {
                    invalidTrigger.toggle()
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isActive = false
                }
                .tint(Color.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
    
    // Individual Character View
    @ViewBuilder
    private func CharacterView(_ index:Int) -> some View {
        Group {
            if style == .roundedBorder {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor(index), lineWidth: 1.2)
            } else {
                Rectangle()
                    .fill(borderColor(index))
                    .frame(height: 1)
                    .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .frame(width: style == .roundedBorder ? 50 : 40, height: 50)
        .overlay {
            // Character
            let stringValue = string(index)
            if stringValue != "" {
                Text(stringValue)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .transition(.blurReplace)
            }
        }
    }
    
    private func string(_ index: Int) -> String {
        if value.count > index {
            let startIndex = value.startIndex
            let stringValue = value.index(startIndex, offsetBy: index)
            return String(value[stringValue])
        }
        return ""
    }
    
    
    private func borderColor(_ index:Int) -> Color {
        switch state {
            // let's highlight active field when the keyboard is active
        case .typing:
            value.count == index && isActive ? Color.primary : .gray
        case .valid:
                .green
        case .invalid:
                .red
        }
    }
}

#Preview {
    ContentView()
}
