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
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder {

    // MARK: - Properties
    var window: UIWindow?
    static var isUITestingEnabled: Bool {
        return ProcessInfo.processInfo.arguments.contains("UI-Testing")
    }
    
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
    
    private func setupCrashlytics() {
        Fabric.with([Crashlytics.self])
    }
    
    private func prepareForUITesting() {
        if AppDelegate.isUITestingEnabled {
            UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
            
            UserManager.shared.pin = nil
            UserManager.shared.companyName = nil
            UserManager.shared.destination = nil
            UserManager.shared.activeInvoice = nil
            UserManager.shared.activePaymentTarget = nil
        }
    }
    
}

extension AppDelegate: UIApplicationDelegate {
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        AnalyticsService.shared.initialize()
        setupRootViewController()
        setupRealm()
        setupCrashlytics()
        NetworkManager.shared.startMonitoring()
        prepareForUITesting()
        
        return true
    }
    
}
