//
//  UIViewExtension.swift
//  VizFaceDetector
//
//  Created by Yaniv Hasbani on 12/07/2019.
//  Copyright © 2019 Yaniv Hasbani. All rights reserved.
//

import UIKit

extension UIView {
  func addGradientToView() {
    //gradient layer
    let gradientLayer = CAGradientLayer()
    
    //define colors
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.cyan.cgColor, UIColor.clear.cgColor]
    
    //define locations of colors as NSNumbers in range from 0.0 to 1.0
    //if locations not provided the colors will spread evenly
    gradientLayer.locations = [0.3, 0.5, 0.7]
    
    gradientLayer.transform = CATransform3DMakeRotation(CGFloat.pi / 4, 0, 0, 1)
    //define frame
    gradientLayer.frame = bounds
    
    //insert the gradient layer to the view layer
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
