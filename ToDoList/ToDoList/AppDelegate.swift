//
//  AppDelegate.swift
//  ToDoList
//
//  Created by Anastasiia Kuzenkova on 23/04/2018.
//  Copyright © 2018 Anastasiia Kuzenkova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let vc = ToDoListViewController()
        let nc = UINavigationController(rootViewController: vc)
        window?.rootViewController = nc

        window?.makeKeyAndVisible()
        
        return true
    }
}
