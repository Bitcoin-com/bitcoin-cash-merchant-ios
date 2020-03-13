//
//  GradientView.swift
//  Merchant
//
//  Created by Djuro Alfirevic on 3/13/20.
//  Copyright © 2020 Bitcoin.com. All rights reserved.
//

import UIKit

final class GradientView: UIView {

    enum Direction {
        case vertical
        case horizontal
    }
    
    // MARK: - Properties
    var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    var direction: Direction = .vertical {
        didSet {
            switch direction {
            case .vertical:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            case .horizontal:
                gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
            }
        }
    }
    var colors: [UIColor] {
        didSet {
            gradientLayer.colors = colors.map({ $0.cgColor })
        }
    }
    
    // MARK: - Layer
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    // MARK: - Initializers
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(colors: [UIColor]) {
        self.colors = colors
        
        super.init(frame: .zero)
        
        gradientLayer.colors = colors.map({ $0.cgColor })
    }

}
