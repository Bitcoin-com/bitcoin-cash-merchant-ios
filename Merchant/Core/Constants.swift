//
//  Constants.swift
//  Merchant
//
//  Created by Jean-Baptiste Dominguez on 2019/04/23.
//  Copyright © 2019 Bitcoin.com. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Strings {
        // Shared
        static let settings = "settings".localized
        
        // Home module
        static let payment = "payment".localized
        static let history = "history".localized
        
        // Settings module
        static let companyName = "company_name".localized
        static let enterCompanyName = "enter_company_name".localized
        static let myCompanyName = "my_company_name".localized
        static let destinationAddress = "destination_address".localized
        static let enterDestinationAddress = "enter_destination_address".localized
        static let scan = "scan".localized
        static let localCurrency = "local_currency".localized
        
        // Scanner module
        static let scanner = "Scanner".localized
        static let openSettings = "open_settings".localized
        static let theCameraIsNecessary = "the_camera_is_necessary".localized
        static let cameraPermissionError = "camera_permission_error".localized
        static let cancel = "cancel".localized
        static let scanningNotSupported = "scanning_not_supported".localized
        static let scanningNotSupportedDetails = "scanning_not_supported_details".localized
        static let ok = "ok".localized
        
        // Payment request module
        static let paymentRequest = "payment_request".localized
        static let waitingForPayment = "waiting_for_payment".localized
        
        // Payment input module
        static let receivingAddressNotAvailable = "receiving_address_not_available".localized
        static let receivingAddressNotAvailableDetails = "receiving_address_not_available_details".localized
    }
}
