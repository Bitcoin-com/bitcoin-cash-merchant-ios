//
//  NSAttributedString+Extensions.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/10/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import Foundation
import CoreGraphics

extension NSAttributedString {

    func height(containerWidth: CGFloat) -> CGFloat {
        let rect = boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }

    func width(containerHeight: CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
    }
    
}
