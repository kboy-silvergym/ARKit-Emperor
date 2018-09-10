//
//  AppDelegate.swift
//  ARKit-Emperor
//
//  Created by Kei Fujikawa on 2018/09/06.
//  Copyright © 2018年 KBOY. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        let navigationAttributes = [
            NSAttributedStringKey.font: UIFont(name: "StarJedi", size: 20),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        UINavigationBar.appearance().titleTextAttributes = navigationAttributes
        return true
    }
}

