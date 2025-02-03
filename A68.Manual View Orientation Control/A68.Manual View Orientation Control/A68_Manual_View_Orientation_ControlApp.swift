//
//  A68_Manual_View_Orientation_ControlApp.swift
//  A68.Manual View Orientation Control
//
//  Created by Kan Tao on 2025/2/3.
//

import SwiftUI

@main
struct A68_Manual_View_Orientation_ControlApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate 
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    // if you want to begin with portrait mode, set this to portrait
    static var orientation: UIInterfaceOrientationMask = .all
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return Self.orientation
    }
}
