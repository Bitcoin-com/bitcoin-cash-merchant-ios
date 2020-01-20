//
//  AppDelegate.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/22.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import UIKit
import RealmSwift
import BDCKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties
    var window: UIWindow?
    
    // MARK: - UIApplicationDelegate
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        setupRealm()
        setupUITestingIfItIsRequired()
        
        // Setup rate manager
        RateManager.shared
        
        let frame = UIScreen.main.bounds
        window = UIWindow(frame: frame)
        
        let rootViewController = HomeBuilder().provide()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window!.rootViewController = navigationController
        
        let navStyles = UINavigationBar.appearance()
        navStyles.barTintColor = BDCColor.white.uiColor
        navStyles.tintColor = BDCColor.primary.uiColor
        navStyles.titleTextAttributes = [NSAttributedString.Key.foregroundColor:BDCColor.primary.uiColor]
        
        window!.makeKeyAndVisible()
        
        SecureAccessService.setup()
        
        return true
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
            
            UserManager.shared.pin = ""
            UserManager.shared.destination = ""
            UserManager.shared.companyName = "Your company name"
        }
    }
    
}
