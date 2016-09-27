//
//  CustomColors.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 01.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

extension UIColor {
  
    static func navigationBarBackgroundColor() -> UIColor {
        return generateColor(23.0, green: 29.0, blue: 32.0, alpha: 1)
    }
    
    static func navigationBarTintColor() -> UIColor {
        return generateColor(171.0, green: 248.0, blue: 189.0, alpha: 1)
    }
    
    static func switchLayoutViewFillColor() -> UIColor {
        return generateColor(171.0, green: 248.0, blue: 189.0, alpha: 1)
    }
    
    static func generateColor(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
}
