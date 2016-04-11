//
//  BaseLayoutAttributes.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 09.03.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

public class BaseLayoutAttributes: UICollectionViewLayoutAttributes {
    
   public var transitionProgress: CGFloat = 0.0
   public var nextLayoutCellFrame = CGRectZero
   public var layoutState: CollectionViewLayoutState = .ListLayoutState
    
    override public func copyWithZone(zone: NSZone) -> AnyObject {
        let copy = super.copyWithZone(zone) as! BaseLayoutAttributes
        copy.transitionProgress = transitionProgress
        copy.nextLayoutCellFrame = nextLayoutCellFrame
        copy.layoutState = layoutState
        
        return copy
    }
    
    override public func isEqual(object: AnyObject?) -> Bool {
        if let attributes = object as? BaseLayoutAttributes {
            if attributes.transitionProgress == transitionProgress && nextLayoutCellFrame == nextLayoutCellFrame  && layoutState == layoutState {
                return super.isEqual(object)
            }
        }
        
        return false
    }
    
}