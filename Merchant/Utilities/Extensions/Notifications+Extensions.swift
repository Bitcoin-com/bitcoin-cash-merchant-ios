//
//  Notifications+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation

extension NSNotification.Name {
    static let showSideMenu = NSNotification.Name("ShowSideMenuNotification")
	static let hideSideMenu = NSNotification.Name("HideSideMenuNotification")
    static let openViewController = NSNotification.Name("OpenViewControllerNotification")
    static let openLink = NSNotification.Name("OpenLinkNotification")
    static let openSettings = NSNotification.Name("OpenSettingsNotification")
    static let createPin = NSNotification.Name("CreatePinNotification")
    static let refreshSettings = NSNotification.Name("RefreshSettingsNotification")
    static let settingsUpdated = NSNotification.Name("SettingsUpdatedNotification")
}
