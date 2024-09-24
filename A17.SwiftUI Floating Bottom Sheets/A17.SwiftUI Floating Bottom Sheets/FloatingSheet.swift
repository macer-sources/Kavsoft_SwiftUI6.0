//
//  FloatingSheet.swift
//  A17.SwiftUI Floating Bottom Sheets
//
//  Created by Kan Tao on 2024/9/24.
//

import SwiftUI


extension View {
    @ViewBuilder
    func floatingBottomSheet<Content: View>(isPresented: Binding<Bool>, onDismiss: @escaping () -> Void = {}, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .sheet(isPresented: isPresented, onDismiss: onDismiss, content: {
                content()
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .background(SheetShadowRemover())
            })
    }
}

fileprivate struct SheetShadowRemover: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView.init(frame: .zero)
        view.backgroundColor = .clear
        // ios  17 +
//        DispatchQueue.main.async {
//            if let uiSheetView = view.viewBeforeWindow {
//                for view in uiSheetView.subviews {
//                    // clearing shadows
//                    view.layer.shadowColor = UIColor.clear.cgColor
//                }
//            }
//        }
        
        // ios 17 -
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
//            if let transitionView = findTransitionView(view: view) {
//                for view in transitionView.subviews {
//                    view.layer.shadowColor = UIColor.clear.cgColor
//                }
//            }
//        }
        // ios 17 - 方式2
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let uiSheetView = view.viewBeforeWindow {
                for view in uiSheetView.subviews {
                    // clearing shadows
                    view.layer.shadowColor = UIColor.clear.cgColor
                }
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIView, context: Context) {

    }
    private func findTransitionView(view: UIView) -> UIView? {
        var superView = view
        while let nextView = superView.superview {
            if nextView.description.hasPrefix("<UITransitionView") {
                return nextView
            }
            superView = nextView
        }
        return nil
    }
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }
}



#Preview {
    ContentView()
}
