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
        static let change = "change".localized
        
        // Scanner module
        static let scanner = "scanner".localized
        static let openSettings = "open_settings".localized
        static let theCameraIsNecessary = "the_camera_is_necessary".localized
        static let cameraPermissionError = "camera_permission_error".localized
        static let cancel = "cancel".localized
        static let scanningNotSupported = "scanning_not_supported".localized
        static let scanningNotSupportedDetails = "scanning_not_supported_details".localized
        static let ok = "ok".localized
        static let pinCode = "pin_code".localized
        
        // Payment request module
        static let paymentRequest = "payment_request".localized
        static let waitingForPayment = "waiting_for_payment".localized
        
        // Payment input module
        static let receivingAddressNotAvailable = "receiving_address_not_available".localized
        static let receivingAddressNotAvailableDetails = "receiving_address_not_available_details".localized
        
        // Pin module
        static let mismatchPin = "mismatch_pin".localized
        static let cancellingPin = "cancelling_pin".localized
        static let pinHasNotBeenChanged = "pin_has_not_been_changed".localized
        static let pinIsRequired = "pin_is_required".localized
        static let tryAgain = "try_again".localized
        static let pinHasBeenChanged = "pin_has_been_changed".localized
        static let success = "success".localized
        static let incorrectPin = "incorrect_pin".localized
        static let operationDenied = "operation_denied".localized
        static let createPinCode = "create_code_pin".localized
        static let enterCurrentPinCode = "enter_current_code_pin".localized
        static let enterPinCode = "enter_pin_code".localized
        static let confirmNewPinCode = "confirm_new_pin_code".localized
        static let enterNewPinCode = "enter_new_pin_code".localized
    }
}
