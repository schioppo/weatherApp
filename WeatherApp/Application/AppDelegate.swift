//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Alessandro Schioppetti on 27/03/2020.
//  Copyright © 2020 Codermine Srl. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = MainViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
        
        return true
    }


}

