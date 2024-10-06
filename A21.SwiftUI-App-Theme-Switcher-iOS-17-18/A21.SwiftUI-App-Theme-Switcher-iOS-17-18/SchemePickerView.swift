//
//  SchemePickerView.swift
//  A21.SwiftUI-App-Theme-Switcher-iOS-17-18
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

enum ThemeScheme : String {
    case dark = "Dark"
    case light = "Light"
    case device = "Device"
}

struct SchemePreview: Identifiable {
    var id = UUID.init()
    var image: UIImage?
    var text: String
}

struct SchemeHostView<Content:View>: View {
    @ViewBuilder var content: Content
    @AppStorage("ThemeScheme") private var themeScheme: ThemeScheme = .device
    @SceneStorage("ShowScenePickerView") private var showPickerView: Bool = false
    
    @State private var showSheet: Bool = false
    @State private var schemePreviews:[SchemePreview] = []
    
    @Environment(\.colorScheme) private var colorScheme
    var body: some View {
        content
            .sheet(isPresented: $showSheet, onDismiss: {
                schemePreviews = []
                showPickerView = false
            }) {
                SchemePickerView(schemePreviews: $schemePreviews)
            }
            .onChange(of: showPickerView) { oldValue, newValue in
                if newValue {
                    generateSchemePreviews()
                }else {
                    showSheet = false
                }
            }
    }
    
    // generating scheme previews and then pushing the sheet view
    private func generateSchemePreviews() {
        Task {
            if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow, schemePreviews.isEmpty {
                let size = window.screen.bounds.size
                let defautStyle = window.overrideUserInterfaceStyle
                
                let defaultSchemePreview = window.subviews.first?.image(size)
                schemePreviews.append(.init( image: defaultSchemePreview, text: colorScheme == .dark ? ThemeScheme.dark.rawValue : ThemeScheme.light.rawValue))
                
                window.overrideUserInterfaceStyle = colorScheme.oppositeInterfaceStyle
                let otherSchemePreviewImage = window.subviews.first?.image(size)
                
                schemePreviews.append(.init( image: otherSchemePreviewImage, text: colorScheme == .dark ? ThemeScheme.light.rawValue : ThemeScheme.dark.rawValue))
                
                // reseting to it\s defaut style
                window.overrideUserInterfaceStyle = defautStyle
                try?  await Task.sleep(for: .seconds(0))
                showSheet = true
                
            }
        }
    }
}

fileprivate extension ColorScheme {
    var oppositeInterfaceStyle: UIUserInterfaceStyle {
        return self == .dark ? .light : .dark
    }
}


struct SchemePickerView: View {
    @Binding var schemePreviews:[SchemePreview]
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appearance")
                .font(.title3.bold())
            
            Spacer()
            
            GeometryReader { _ in
                HStack(spacing: 0) {
                    ForEach(schemePreviews) { preview in
                        SchemeCardView(preview)
                    }
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background {
            ZStack {
                Rectangle()
                    .fill(.background)
                Rectangle()
                    .fill(Color.primary.opacity(0.05))
            }
            .clipShape(.rect(cornerRadius: 20))
        }
        .padding(.horizontal, 15)
        .presentationDetents([.height(350)])
        .presentationBackground(.clear)
    }
    
    
    @ViewBuilder
    private func SchemeCardView(_ preview: SchemePreview) -> some View {
        VStack(spacing: 4) {
            if let image = preview.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            Text(preview.text)
                .font(.caption)
                .foregroundStyle(.gray)
            
            ZStack {
                Image(systemName: "circle")
            }
        }
    }
}

extension UIView {
    func image(_ size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            drawHierarchy(in: .init(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}
