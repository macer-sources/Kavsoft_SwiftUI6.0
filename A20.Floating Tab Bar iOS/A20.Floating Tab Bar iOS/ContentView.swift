//
//  ContentView.swift
//  A20.Floating Tab Bar iOS
//
//  Created by Kan Tao on 2024/10/6.
//

import SwiftUI

struct ContentView: View {
    @State private var activeTab: TabModel = .home
    
    @State private var isTabBarHidden: Bool  = false
    var body: some View {
        ZStack(alignment: .bottom, content: {
            Group {
                tabbar()
            }
            CustomTabBar(activeTab: $activeTab)
        })

    }
    
    
    @ViewBuilder
    private func tabbar() -> some View {
        if #available(iOS 18, *) {
            TabView(selection: $activeTab,
                    content:  {
                Tab.init(value: .home) {
                    HomeView()
                        .toolbar(.hidden, for: .tabBar)
                }
            })
        } else {
            TabView(selection: $activeTab,
                    content:  {
                HomeView()
                    .tag(TabModel.home)
                    .background {
                        if !isTabBarHidden {
                            HideTabBar {
                                isTabBarHidden = true
                            }
                        }
                    }
                
                Text("Search")
                    .tag(TabModel.search)
                
                Text("Notifications")
                    .tag(TabModel.notifications)
                
                Text("Settings")
                    .tag(TabModel.settings)
                
                
            })
        }
    }
}

struct HideTabBar: UIViewRepresentable {
    var result:() -> Void
    func makeUIView(context: Context) -> some UIView {
        let view = UIView.init()
        view.backgroundColor = .clear
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            if let tabbarController = view.tabbarController {
                tabbarController.tabBar.isHidden = true
                result()
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

extension UIView {
    var tabbarController: UITabBarController? {
        if let controller = sequence(first: self, next: {
            $0.next
        }).first(where: {$0 is UITabBarController}) as? UITabBarController {
            return controller
        }
        return nil
    }
}


struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(spacing: 12) {
                    ForEach(1...50,id:\.self) { _ in
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.background)
                            .frame(height: 50)
                    }
                }
                .padding(10)
            }
            .navigationTitle("Floating Tab")
            .background(Color.primary.opacity(0.06))
            // TODO: 底部的安全距离
            .safeAreaPadding(.bottom, 60)
        }
    }
}



#Preview {
    ContentView()
}
