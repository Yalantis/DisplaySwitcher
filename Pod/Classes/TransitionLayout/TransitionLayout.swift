//
//  TransitionLayout.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

open class TransitionLayout: UICollectionViewTransitionLayout {
    
    var layoutState: LayoutState?
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let currentAttributes = super.layoutAttributesForElements(in: rect)!
        setupNextLayout(with: currentAttributes, in: rect)
        
        return currentAttributes
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.layoutAttributesForItem(at: indexPath)
        if let layoutAttributes = attributes as? DisplaySwitchLayoutAttributes {
            layoutAttributes.transitionProgress = transitionProgress
            if let layoutState = layoutState {
                layoutAttributes.layoutState = layoutState
            }
            if let nextLayoutAttributes = nextLayout.layoutAttributesForItem(at: indexPath) as? DisplaySwitchLayoutAttributes {
                    layoutAttributes.nextLayoutCellFrame = nextLayoutAttributes.frame
            }
        }
        
        return attributes
    }
    
}

fileprivate extension TransitionLayout {
    
    func setupNextLayout(with currentAttributes: [UICollectionViewLayoutAttributes], `in` rect: CGRect) {
        let nextAttributes = nextLayout.layoutAttributesForElements(in: rect)
        for index in 0..<currentAttributes.count {
            if let currentLayoutAttributes = currentAttributes[index] as? DisplaySwitchLayoutAttributes {
                currentLayoutAttributes.transitionProgress = transitionProgress
                if let layoutState = layoutState {
                    currentLayoutAttributes.layoutState = layoutState
                }
                if let nextAttributes = nextAttributes, nextAttributes.count > index {
                    if let nextLayoutAttributes = nextAttributes[index] as? DisplaySwitchLayoutAttributes {
                        currentLayoutAttributes.nextLayoutCellFrame = nextLayoutAttributes.frame
                    }
                }
            }
        }
    }
    
}
