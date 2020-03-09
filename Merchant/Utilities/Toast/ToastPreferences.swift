//
//  ToastPreferences.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 2/20/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import UIKit

final class ToastPreferences {
	
	// MARK: - Properties
	var inset: CGFloat = 15.0
	var messageDuration = 1.0
    var cornerRadius: CGFloat = 0.0
    var animationDuration = 0.25
	var containerColor: UIColor = .white
    var successContainerColor: UIColor = .bitcoinDarkerGreen
    var failureContainerColor: UIColor = .red
	var textColor: UIColor = .white
	var autoclosing = true
    var font: UIFont = .systemFont(ofSize: 16.0)
    
    // MARK: - Public API
    func color(for status: ToastStatus) -> UIColor {
        switch status {
        case .failure:
            return failureContainerColor
        default:
            return successContainerColor
        }
    }
	
}
