//
//  ContentView.swift
//  A68.Manual View Orientation Control
//
//  Created by Kan Tao on 2025/2/3.
//

import SwiftUI


enum Orientation: String, CaseIterable {
    case all
    case portrait
    case landscapeLeft
    case landscapeRight
    
    var mask: UIInterfaceOrientationMask {
        switch self {
        case.all:
            return .all
        case .portrait:
            return.portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        }
    }
}

struct ContentView: View {
    @State private var orientation: Orientation = .portrait
    var body: some View {
        NavigationStack {
            List {
                Section("Orientation") {
                    Picker("", selection: $orientation) {
                        ForEach(Orientation.allCases, id:\.rawValue) {orientation in
                            Text(orientation.rawValue).tag(orientation)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: orientation,initial: true) { oldValue, newValue in
                        modifyOrientation(newValue.mask)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}



extension View {
    // easy to use function to update orientation anywhere in view scope
    func modifyOrientation(_ mask: UIInterfaceOrientationMask) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // finally limiting the auto-rotation by setting orentation mask on appdelegate
            AppDelegate.orientation = mask
            windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: mask))
            // updating root view controller
            windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
