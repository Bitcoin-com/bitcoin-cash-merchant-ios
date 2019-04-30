//
//  AppDelegate.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRealm()
        setupUITestingIfItIsRequired()
        
        // Setup rate manager
        RateManager.shared
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        let rootViewController = HomeBuilder().provide()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        let navStyles = UINavigationBar.appearance()
        navStyles.barTintColor = BDCColor.white.uiColor
        navStyles.tintColor = BDCColor.green.uiColor
        navStyles.titleTextAttributes = [NSAttributedString.Key.foregroundColor:BDCColor.green.uiColor]
        
        window!.rootViewController = navigationController
        window!.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

extension AppDelegate {
    
    fileprivate func setupRealm() {
        // Realm migration
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
//                if (oldSchemaVersion < 1) {
//                    migration.renameProperty(onType: "Class", from: "oldField", to: "newField")
//                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    fileprivate func setupUITestingIfItIsRequired() {
        if ProcessInfo.processInfo.arguments.contains("MerchantUITests") {
            
            // Clean realm
            let realm = try! Realm()
            try! realm.write {
                realm.deleteAll()
            }
        }
    }
}
