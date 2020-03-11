//
//  AppDelegate.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift
import Amplitude_iOS

@UIApplicationMain
class AppDelegate: UIResponder {

    // MARK: - Properties
    var window: UIWindow?
    
    // MARK - Private API
    private func setupRootViewController() {
        let navigationController = UINavigationController(rootViewController: ContainerViewController())
        navigationController.isNavigationBarHidden = true
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func setupRealm() {
        let config = Realm.Configuration(schemaVersion: 1, migrationBlock: { migration, oldSchemaVersion in })
        Realm.Configuration.defaultConfiguration = config
    }
    
}

extension AppDelegate: UIApplicationDelegate {
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AnalyticsService.shared.initialize()
        setupRootViewController()
        setupRealm()
        NetworkManager.shared.startMonitoring()
        
        return true
    }
    
}
