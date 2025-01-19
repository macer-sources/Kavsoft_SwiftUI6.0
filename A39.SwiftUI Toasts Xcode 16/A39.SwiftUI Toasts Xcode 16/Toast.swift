//
//  Toast.swift
//  SwiftUI Toasts _ Xcode 16
//
//  Created by 10191280 on 2024/10/24.
//

import SwiftUI


struct Toast : Identifiable {
    private(set) var id = UUID().uuidString
    var content: AnyView
    
    init(@ViewBuilder content: @escaping (String) -> some View) {
        self.content = .init(content(id))
    }
    // view properties
    var offsetX: CGFloat = 0
    var isDeleting: Bool = false
}

extension View {
    @ViewBuilder
    func interactiveToasts(_ toasts:Binding<[Toast]>) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(alignment: .bottom) {
                ToastsView(toasts: toasts)
            }
    }
}

fileprivate struct ToastsView: View {
    @Binding var toasts:[Toast]
    @State private var isExpended: Bool = false
    var body: some View {
        ZStack(alignment: .bottom, content: {
            if isExpended {
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isExpended = false
                    }
            }
            
            let layout = isExpended ? AnyLayout(VStackLayout(spacing: 10)) : AnyLayout(ZStackLayout())
            layout {
                ForEach($toasts) { $toast in
                    let index = (toasts.count - 1) -  (toasts.firstIndex(where: {$0.id == toast.id}) ?? 0)
                    toast.content
                        .offset(x: toast.offsetX)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    let xOffset = value.translation.width < 0 ? value.translation.width : 0
                                    toast.offsetX = xOffset
                                }).onEnded({ value in
                                    let xOffset = value.translation.width + (value.velocity.width / 2)
                                    if -xOffset > 200 {
                                        //remove toast
                                        $toasts.delete(toast.id)
                                    } else {
                                        // reset toast to it's initial position
                                        toast.offsetX = 0
                                    }
                                })
                        )
                        .visualEffect { [isExpended] content, geometryProxy in
                            content
                                .scaleEffect(isExpended ? 1 :  scale(index), anchor: .bottom)
                                .offset(y: isExpended ? 0 : offsetY(index))
                        }
                        .zIndex(toast.isDeleting ? 1000 : 0)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(insertion: .offset(y: 100), removal: .move(edge: .leading)))
                }
            }
            .onTapGesture {
                isExpended.toggle()
            }
            .padding(.bottom, 15)
        })
        .animation(.bouncy, value: isExpended)
        .onChange(of: toasts.isEmpty) { oldValue, newValue in
            if newValue {
                isExpended = false
            }
        }
    }
    
    nonisolated func offsetY(_ index: Int) -> CGFloat {
        let offset = min(CGFloat(index) * 15, 30)
        return -offset
    }
    
    nonisolated func scale(_ index: Int) -> CGFloat {
        let scale = min(CGFloat(index) * 0.1, 1)
        return  1 - scale
    }
}


extension Binding<[Toast]> {
    func delete(_ id: String) {
        if let toast = first(where: {$0.id == id}) {
            toast.wrappedValue.isDeleting = true
        }
        withAnimation(.bouncy) {
            self.wrappedValue.removeAll(where: {$0.id == id})
        }
    }
}

#Preview {
    ContentView()
}
