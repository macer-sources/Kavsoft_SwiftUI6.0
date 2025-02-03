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
    @State private var showFullScreenCover: Bool = false
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
                
                
                Section("Actions") {
                    NavigationLink("Detail View") {
                        DetailView(userSelection: orientation)
                    }
                    
                    Button("Show Full Screen Cover") {
                        modifyOrientation(.landscapeRight)
                        // The reason I'm using DispatchQueue is to have animation for the full-screen cover as well
                        DispatchQueue.main.async {
                            showFullScreenCover.toggle()
                        }
                    }
                }
                
                
            }
        }
        .navigationTitle("Manual Orientation")
        .fullScreenCover(isPresented: $showFullScreenCover) {
            Rectangle()
                .fill(.red.gradient)
                .overlay {
                    Text("Hello From Full Screen Cover!")
                }
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing) {
                    Button("Close") {
                        modifyOrientation(orientation.mask)
                        showFullScreenCover.toggle()
                    }
                    .padding(15)
                }
        }
    }
}


struct DetailView: View {
    var userSelection: Orientation
    @Environment(\.dismiss) private var dismiss
    @State private var isRotated: Bool = false
    var body: some View {
        NavigationLink("Sub-Detail View"){
            Text("Hello From Detail View!")
                .onAppear {
                    modifyOrientation(.portrait)
                }.onDisappear {
                    modifyOrientation(.landscapeLeft)
                }
        }
            .onAppear {
                guard !isRotated else { return }
                modifyOrientation(.landscapeLeft)
                isRotated = true
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Back") {
                        modifyOrientation(userSelection.mask)
                        DispatchQueue.main.async {
                            dismiss()
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
