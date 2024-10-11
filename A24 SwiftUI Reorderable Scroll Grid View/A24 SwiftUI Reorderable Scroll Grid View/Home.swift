//
//  Home.swift
//  A24 SwiftUI Reorderable Scroll Grid View
//
//  Created by Kan Tao on 2024/10/11.
//

import SwiftUI


struct Home: View {
    var safeArea: EdgeInsets
    @State private var controls:[ControlItem] = controlsList
    @State private var selectedControl: ControlItem?
    @State private var selectedControlScale: CGFloat = 1.0
    @State private var selectedControlFrame: CGRect = .zero
    @State private var offset: CGSize = .zero
    // opational fefature
    @State private var hapticsTrigger: Bool = false
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 20, content: {
                ForEach($controls) { $control in
                    ControlView(control: control)
                        .opacity(selectedControl?.id == control.id ? 0 : 1)
                    // filling up the frame property with the help of new ongeomertyModifier
                        .onGeometryChange(for: CGRect.self) {
                            $0.frame(in: .global)
                        } action: { newValue in
                            if selectedControl?.id == control.id {
                                selectedControlFrame = newValue
                            }
                            control.frame = newValue
                        }
                        .gesture(customCombinedGesture(control))

                }
            })
            .padding(25)
        }
        .scrollIndicators(.hidden)
        .overlay(alignment: .topLeading) {
            if let selectedControl {
                ControlView(control: selectedControl)
                    .frame(width: selectedControl.frame.width, height: selectedControl.frame.height)
                    .scaleEffect(selectedControlScale)
                    .offset(x: selectedControl.frame.minX, y: selectedControl.frame.minY)
                    .offset(offset)
                    .ignoresSafeArea()
                    .transition(.identity)
            }
        }
        .sensoryFeedback(.impact, trigger: hapticsTrigger)
    }
}

extension Home {
    private func customCombinedGesture(_ control: ControlItem) -> some Gesture {
        LongPressGesture(minimumDuration: 0.25)
            .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .global))
            .onChanged { value in
                switch value {
                case .second(let status, let value):
                    if status {
                        if selectedControl == nil {
                            selectedControl = control
                            selectedControlFrame = control.frame
                            hapticsTrigger.toggle()
                            
                            withAnimation(.smooth(duration: 0.25, extraBounce: 0)) {
                                selectedControlScale = 1.05
                            }
                        }
                        
                        if let value {
                            offset = value.translation
                            let location = value.location
                            checkAndSwapItems(location)
                        }
                    }
                default: ()
                }
            }
            .onEnded { _ in
                withAnimation(.snappy(duration: 0.25, extraBounce: 0),completionCriteria: .logicallyComplete) {
                    // updating control frame with latest update
                    selectedControl?.frame = selectedControlFrame
                    
                    selectedControlScale = 1.0
                    offset = .zero
                } completion: {
                    selectedControl = nil
                }

            }
    }
    
    
    private func checkAndSwapItems(_ location: CGPoint) {
        if let currentIndex = controls.firstIndex(where: {$0.id == selectedControl?.id}),
           let fallingIndex = controls.firstIndex(where: {$0.frame.contains(location)}) {
            withAnimation(.snappy(duration: 0.25,extraBounce: 0)) {
                (controls[currentIndex], controls[fallingIndex]) = (controls[fallingIndex], controls[currentIndex])
            }
        }
    }
}



fileprivate struct ControlView: View {
    var control: ControlItem
    var body: some View {
        HStack(spacing: 15, content: {
            Image(systemName: control.symbol)
                .font(.title3)
            
            Text(control.title)
            
            Spacer(minLength: 0)
        })
        .padding(.horizontal, 15)
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
        }
    }
}



#Preview {
    ContentView()
}
