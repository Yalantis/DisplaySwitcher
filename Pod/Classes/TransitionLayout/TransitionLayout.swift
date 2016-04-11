//
//  TransitionLayout.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

public class TransitionLayout: UICollectionViewTransitionLayout {
    
    var layoutState: CollectionViewLayoutState?
    
    // MARK: - UICollectionViewLayout
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let currentAttributes = super.layoutAttributesForElementsInRect(rect)!
        let nextAttributes = nextLayout.layoutAttributesForElementsInRect(rect)
        for index in 0..<currentAttributes.count {
            if let currentLayoutAttributes = currentAttributes[index] as? BaseLayoutAttributes {
                currentLayoutAttributes.transitionProgress = transitionProgress
                if let layoutState = layoutState {
                    currentLayoutAttributes.layoutState = layoutState
                }
                if nextAttributes?.count > index {
                    if let nextLayoutAttributes = nextAttributes![index] as? BaseLayoutAttributes {
                        currentLayoutAttributes.nextLayoutCellFrame = nextLayoutAttributes.frame
                    }
                }
            }
        }
        
        return currentAttributes
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        if let layoutAttributes = attributes as? BaseLayoutAttributes {
            layoutAttributes.transitionProgress = transitionProgress
            if let layoutState = layoutState {
                layoutAttributes.layoutState = layoutState
            }
            if let nextLayoutAttributes = nextLayout.layoutAttributesForItemAtIndexPath(indexPath) as? BaseLayoutAttributes {
                    layoutAttributes.nextLayoutCellFrame = nextLayoutAttributes.frame
            }
        }
        
        return attributes
    }
    
}
