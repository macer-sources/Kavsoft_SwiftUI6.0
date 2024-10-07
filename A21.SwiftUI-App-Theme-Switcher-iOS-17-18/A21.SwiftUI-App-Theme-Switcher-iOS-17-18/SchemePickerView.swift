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
    private var content: Content
    @AppStorage("ThemeScheme") private var themeScheme: ThemeScheme = .device
    @SceneStorage("ShowScenePickerView") private var showPickerView: Bool = false
    
    @State private var showSheet: Bool = false
    @State private var schemePreviews:[SchemePreview] = []
    
    @State private var overlayWindow: UIWindow?
    
    
    @Environment(\.colorScheme) private var colorScheme
    
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            window.overrideUserInterfaceStyle = themeScheme == .dark ? .dark : (themeScheme == .light ? .light : .unspecified)
        }
    }
    
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
            .onAppear {
                if let scene = (UIApplication.shared.connectedScenes.first as? UIWindowScene) , overlayWindow == nil {
                    let window = UIWindow(windowScene: scene)
                    window.backgroundColor = .clear
                    window.isHidden = false
                    window.isUserInteractionEnabled = false
                    let emptyController = UIViewController()
                    emptyController.view.backgroundColor = .clear
                    window.rootViewController = emptyController
                    
                    overlayWindow = window
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
                
                showOverlayImageView(defaultSchemePreview)
                
                window.overrideUserInterfaceStyle = colorScheme.oppositeInterfaceStyle
                let otherSchemePreviewImage = window.subviews.first?.image(size)
                
                schemePreviews.append(.init( image: otherSchemePreviewImage, text: colorScheme == .dark ? ThemeScheme.light.rawValue : ThemeScheme.dark.rawValue))
                
                if themeScheme == .dark {
                    schemePreviews = schemePreviews.reversed()
                }
                
                // reseting to it\s defaut style
                window.overrideUserInterfaceStyle = defautStyle
                try?  await Task.sleep(for: .seconds(0))
                
                removeOverlayImageView()
                showSheet = true
                
            }
        }
    }
    
    
    private func showOverlayImageView(_ image: UIImage?) {
        if overlayWindow?.rootViewController?.view.subviews.isEmpty ?? false  {
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            
            overlayWindow?.rootViewController?.view.addSubview(imageView)
        }
    }
    private func removeOverlayImageView() {
        overlayWindow?.rootViewController?.view.subviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
}

fileprivate extension ColorScheme {
    var oppositeInterfaceStyle: UIUserInterfaceStyle {
        return self == .dark ? .light : .dark
    }
}


struct SchemePickerView: View {
    @AppStorage("ThemeScheme") private var themeScheme: ThemeScheme = .device
    @Binding var schemePreviews:[SchemePreview]
    // AppStorage 变更不会更新UI的， 所以需要这个属性
    @State private var localSchemeState: ThemeScheme = .device
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Appearance")
                .font(.title3.bold())
            
            Spacer()
            
            GeometryReader { _ in
                HStack(spacing: 0) {
                    ForEach(schemePreviews) { preview in
                        SchemeCardView([preview])
                    }
                    SchemeCardView(schemePreviews)
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
        .onChange(of: themeScheme) { oldValue, newValue in
            localSchemeState = newValue
        }
        .animation(.easeInOut(duration: 0.25), value: themeScheme)
    }
    
    
    @ViewBuilder
    private func SchemeCardView(_ preview: [SchemePreview]) -> some View {
        VStack(spacing: 4) {
            if let image = preview.first?.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        if let secondImage = preview.last?.image, preview.count == 2 {
                            GeometryReader {
                                let width = $0.size.width / 2
                                Image(uiImage: secondImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .mask(alignment: .trailing) {
                                        Rectangle()
                                            .frame(width: width)
                                    }
                            }
                        }
                    }
                    .clipShape(.rect(cornerRadius: 15))
            }
            
            let text = preview.count == 2 ? "Device" : preview.first?.text ?? ""
            
            Text(text)
                .font(.caption)
                .foregroundStyle(.gray)
            
            ZStack {
                Image(systemName: "circle")
                
                if localSchemeState.rawValue == text {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.primary)
                        .transition(.blurReplace)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(.rect)
        .onTapGesture {
            if preview.count == 2 {
                themeScheme = .device
            }else {
                themeScheme = preview.first?.text == ThemeScheme.dark.rawValue ? .dark : .light
            }
            
            updateScheme()
        }
    }
    
    
    private func updateScheme() {
        if let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow {
            window.overrideUserInterfaceStyle = themeScheme == .dark ? .dark : (themeScheme == .light ? .light : .unspecified)
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
