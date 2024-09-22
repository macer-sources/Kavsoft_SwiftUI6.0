//
//  ContentView.swift
//  A09-Removing More Button from Tab bar
//
//  Created by Kan Tao on 2024/9/22.
//

import SwiftUI

enum TabModel: String, CaseIterable {
    case home = "house.fill"
    case search = "magnifyingglass"
    case notifications = "bell.fill"
    case bookmarks = "bookmark.fill"
    case communities = "person.2.fill"
    case settings = "gearshape.fill"
}


struct ContentView: View {
    @State private var activeTab: TabModel = .home
    @State private var isHidden: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                Tab.init(value: .home) {
                    Text("Home")
                        .toolbarVisibility(.hidden, for: .tabBar)
                        .background {
                            if !isHidden {
                                RemoveMoreNavigationBar {
                                    isHidden = true
                                }
                            }
                        }
                }
                Tab.init(value: .search) {
                    Text("search")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .notifications) {
                    Text("notifications")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .bookmarks) {
                    Text("bookmarks")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .communities) {
                    Text("communities")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
                Tab.init(value: .settings) {
                    Text("settings")
                        .toolbarVisibility(.hidden, for: .tabBar)
                }
            }
            CustomTabBar()
        }
    }
    
    
    @ViewBuilder
    func CustomTabBar() -> some View {
        HStack(spacing: 0) {
            ForEach(TabModel.allCases,id:\.rawValue) { tab in
                Button {
                    activeTab = tab
                } label: {
                    Image(systemName: tab.rawValue)
                        .font(.title3 )
                        .foregroundStyle(activeTab == tab ? Color.primary : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .contentShape(.rect)
                }

            }
        }
    }
}


struct RemoveMoreNavigationBar: UIViewRepresentable {
    var result:() -> Void
    func makeUIView(context: Context) -> some UIView {
        let view = UIView.init()
        view.backgroundColor = .clear
        DispatchQueue.main.async {
            if let tabbarController  = view.tabbarController {
                tabbarController.moreNavigationController.navigationBar.isHidden = true
                result()
            }
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}


//finding attached uitabbar
extension UIView {
    var tabbarController: UITabBarController? {
        if let controller = sequence(first: self) { item in
            item.next
        }.first(where: {$0 is UITabBarController}) as? UITabBarController {
            return controller
        }
        return nil
    }
}


#Preview {
    ContentView()
}
