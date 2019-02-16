//
//  RoundCorners.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-16.
//  Copyright © 2016 Yung Dai. All rights reserved.
//

import UIKit

@IBDesignable final class RoundedCornerView: UIView {

    @IBInspectable public var radius: CGFloat = 20
    @IBInspectable public var hasShadow: Bool = true

    private var maskLayer = CAShapeLayer()
    private var corners = UIRectCorner()
    
    let shadowLayer = CAShapeLayer()
    
    @IBInspectable var topLeftCorner: Bool = false {
        didSet {

            if topLeftCorner {
                
                corners.update(with: .topLeft)
            } else {
                
                corners.remove(.topLeft)
            }
        }
    }
    
    @IBInspectable var bottomLeftCorner: Bool = false {
        didSet {

            if bottomLeftCorner {
                
                corners.update(with: .bottomLeft)
            } else {
                
                corners.remove(.bottomLeft)
            }
        }
    }
    
    @IBInspectable var topRightCorner: Bool = false {
        didSet {
            
            if topRightCorner {
                
                corners.update(with: .topRight)
            } else {
                
                corners.remove(.topRight)
            }
        }
    }
    
    @IBInspectable var bottomRightCorner: Bool = false {
        didSet {
            
            if bottomRightCorner {
                
                corners.update(with: .bottomRight)
            } else {
                
                corners.remove(.bottomRight)
            }
        }
    }

    @IBInspectable public var boxColor: UIColor?
    @IBInspectable var shadowColour: UIColor = UIColor.black
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 5, height: 5)
    @IBInspectable var shadowRadius: CGFloat = 5.0
    @IBInspectable public var shadowOpacity: Float = 1.0
    
    public func animateShadowOpacity(fromValue: CGFloat, toValue: CGFloat, duration: TimeInterval) {
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.isRemovedOnCompletion = false
        shadowAnimation.fromValue = fromValue
        shadowAnimation.toValue = toValue
        shadowAnimation.duration = duration
        self.shadowOpacity = Float(toValue)
        shadowLayer.add(shadowAnimation, forKey: shadowAnimation.keyPath)
        shadowLayer.shadowOpacity = Float(toValue)

    }
    
    override public func draw(_ rect: CGRect) {
    super.draw(rect)

        // makes sure that all sublayers are removed when redrawn.
  
        drawRoundedSides(rect)

        if hasShadow {
            maskLayer.fillColor = boxColor?.cgColor
            
            shadowLayer.shadowColor = shadowColour.cgColor
            shadowLayer.shadowOffset = shadowOffset
            shadowLayer.shadowRadius = shadowRadius
            shadowLayer.shadowOpacity = shadowOpacity
            shadowLayer.shadowPath = maskLayer.path

            self.layer.insertSublayer(shadowLayer, at: 0)
            self.layer.insertSublayer(maskLayer, at: 1)
            self.backgroundColor = UIColor.clear
        } else {
            
            self.layer.mask = maskLayer
            self.layer.masksToBounds = true
        }
    }
    
    private func drawRoundedSides(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: self.corners, cornerRadii: CGSize(width: radius, height: radius))
        maskLayer.path = path.cgPath
        self.setNeedsDisplay()
    }
}
