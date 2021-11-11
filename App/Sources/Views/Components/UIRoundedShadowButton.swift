//
//  UIRoundedShadowButton.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import UIKit

final class UIRoundedShadowButton: UIButton {

    private var shadowLayer: CAShapeLayer!
    
    public var cornerRadius: CGFloat = 8 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var shadowOpacity: Float = 0.6 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var shadowRadius: CGFloat = 2 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    public var fillColor: UIColor? {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if self.shadowLayer == nil {
            self.shadowLayer = CAShapeLayer()
            self.shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
            self.shadowLayer.fillColor = self.fillColor?.cgColor

            self.shadowLayer.shadowColor = UIColor.darkGray.cgColor
            self.shadowLayer.shadowPath = shadowLayer.path
            self.shadowLayer.shadowOffset = CGSize(width: 0, height: 1.0)
            self.shadowLayer.shadowOpacity = self.shadowOpacity
            self.shadowLayer.shadowRadius = self.shadowRadius

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
}
