//
//  GripView.swift
//  500pxDemo
//
//  Created by Yung Dai on 2019-02-16.
//  Copyright © 2019 Yung Dai. All rights reserved.
//

import UIKit

@IBDesignable final class GripView: UIView {

    override func draw(_ rect: CGRect) {
      super.draw(rect)
        
        layer.cornerRadius = bounds.height / 2
        layer.masksToBounds = true
        clipsToBounds = true
        
    }
}
