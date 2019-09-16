//
//  AppDelegate.swift
//  TinkoffPoints
//
//  Created by Alexander Makarov on 16/09/2019.
//  Copyright © 2019 magrus87. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private var router: AppRouter?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        router = AppRouter(mainWindow: window)
        router?.showDepositPointsScreen()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppPersistentContainer.shared.saveContext()
    }
}

