//
//  ContentView.swift
//  A02-Text Renderer API
//
//  Created by Kan Tao on 2024/8/11.
//

import SwiftUI

struct ContentView: View {
    @State private var reveal = false
    @State private var type: RevealRenderer.RevealType = .blur
    @State private var progress: CGFloat = 0
    var body: some View {
        NavigationStack {
            VStack {
                Picker("", selection: $type) {
                    ForEach(RevealRenderer.RevealType.allCases, id:\.rawValue) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)
                
                let apiKey = Text("1dnkfndaknfdkanfkda")
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.primary)
                    .customAttribute(APIKeyAttribute())
                
                Text("Your API Key is \(apiKey) \n Don't share this with anyone.")
                    .font(.title3)
                    .fontDesign(.rounded)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .foregroundStyle(.gray)
                    .textRenderer(RevealRenderer(type: type, progress: progress))
                    .padding(.vertical, 20)
                
                Button {
                    reveal.toggle()
                    withAnimation {
                        progress = reveal ? 1 : 0
                    }
                } label: {
                    Text(reveal ?  "Hide Key" : "reveal Key")
                        .padding(.horizontal, 25)
                        .padding(.vertical, 5)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .tint(.black)

                
                Spacer(minLength: 0)
            }
            .padding(15)
            .navigationTitle("Text Renderer")
        }
    }
}

#Preview {
    ContentView()
}

// text attribute
struct APIKeyAttribute: TextAttribute {
    // additional properties
}

// custom renderer
struct RevealRenderer: TextRenderer, Animatable {
    var type: RevealType = .blur
    var progress: CGFloat
    var animatableData: CGFloat {
        get {progress }
        set {progress = newValue}
    }
    func draw(layout: Text.Layout, in ctx: inout GraphicsContext) {
        let allLines = layout.flatMap({$0})
//        let allRunds = allLines.flatMap({$0})
        
        for line in allLines {
            if let _ = line[APIKeyAttribute.self] {
                var localContext = ctx
                let isBlur = type == .blur
                
                // 使用blur filter
                let blurProgress: CGFloat = 5 - (5 * progress)
                let blurFilter = GraphicsContext.Filter.blur(radius: blurProgress)

                
                // metal
                let pixellatProgress:CGFloat = 5 - (4 * progress)
                let pixellatedFilter = GraphicsContext.Filter.distortionShader(ShaderLibrary.pixellate(.float(pixellatProgress)), maxSampleOffset: .zero)
                localContext.addFilter(isBlur ? blurFilter : pixellatedFilter)
                
                localContext.draw(line)
            } else {
                let localContext = ctx
                localContext.draw(line)
            }
        }
    }
    
    
    enum RevealType: String, CaseIterable {
        case blur = "Blur"
        case pixellate = "Pixellate"
    }
    
}
