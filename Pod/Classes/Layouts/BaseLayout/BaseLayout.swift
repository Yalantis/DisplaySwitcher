//
//  BaseLayout.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 29.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let listLayoutCountOfColumns = 1
private let gridLayoutCountOfColumns = 3

public enum CollectionViewLayoutState {
    case ListLayoutState
    case GridLayoutState
}

public class BaseLayout: UICollectionViewLayout {
    
    private let numberOfColumns: Int
    private let cellPadding: CGFloat = 6.0
    private let staticCellHeight: CGFloat
    private let nextLayoutStaticCellHeight: CGFloat
    private var previousContentOffset: NSValue?
    private var layoutState: CollectionViewLayoutState
  
    private var baseLayoutAttributes: [BaseLayoutAttributes]!
    
    private var contentHeight: CGFloat = 0.0
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - insets.left - insets.right
    }
    
    // MARK: - Lifecycle
  
    public init(staticCellHeight: CGFloat, nextLayoutStaticCellHeight: CGFloat, layoutState: CollectionViewLayoutState) {
        self.staticCellHeight = staticCellHeight
        self.numberOfColumns = (layoutState == .ListLayoutState) ? listLayoutCountOfColumns : gridLayoutCountOfColumns
        self.layoutState = layoutState
        self.nextLayoutStaticCellHeight = nextLayoutStaticCellHeight
        
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
  
    override public func prepareLayout() {
        super.prepareLayout()
        
        baseLayoutAttributes = [BaseLayoutAttributes]()
        
        // cells layout
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsets = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](count: numberOfColumns, repeatedValue: contentHeight)
        for item in 0 ..< collectionView!.numberOfItemsInSection(0) {
            let indexPath = NSIndexPath(forItem: item, inSection: 0)
            let height = cellPadding + staticCellHeight
            let frame = CGRect(x: xOffsets[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = CGRectInset(frame, cellPadding, cellPadding)
            let attributes = BaseLayoutAttributes(forCellWithIndexPath: indexPath)
            attributes.frame = insetFrame
            baseLayoutAttributes.append(attributes)
            contentHeight = max(contentHeight, CGRectGetMaxY(frame))
            yOffset[column] = yOffset[column] + height
            column = column == (numberOfColumns - 1) ? 0 : ++column
        }
    }
    
    override public func collectionViewContentSize() -> CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override public func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in baseLayoutAttributes {
            if CGRectIntersectsRect(attributes.frame, rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }
    
    override public func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        return baseLayoutAttributes[indexPath.row]
    }
    
    override public class func layoutAttributesClass() -> AnyClass {
        return BaseLayoutAttributes.self
    }
    
    // Fix bug with content offset
    override public func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint) -> CGPoint {
        let previousContentOffsetPoint = previousContentOffset?.CGPointValue()
        let superContentOffset = super.targetContentOffsetForProposedContentOffset(proposedContentOffset)
        if let previousContentOffsetPoint = previousContentOffsetPoint {
            if previousContentOffsetPoint.y == 0 {
                return previousContentOffsetPoint
            }
            if layoutState == CollectionViewLayoutState.ListLayoutState {
                let offsetY = ceil(previousContentOffsetPoint.y + (staticCellHeight * previousContentOffsetPoint.y / nextLayoutStaticCellHeight) + cellPadding)
                return CGPoint(x: superContentOffset.x, y: offsetY)
            } else {
                let realOffsetY = ceil((previousContentOffsetPoint.y / nextLayoutStaticCellHeight * staticCellHeight / CGFloat(numberOfColumns)) - cellPadding)
                let offsetY = floor(realOffsetY / staticCellHeight) * staticCellHeight + cellPadding
                return CGPoint(x: superContentOffset.x, y: offsetY)
            }
        }
        
        return superContentOffset
    }
    
    override public func prepareForTransitionFromLayout(oldLayout: UICollectionViewLayout) {
        previousContentOffset = NSValue(CGPoint:collectionView!.contentOffset)
        
        return super.prepareForTransitionFromLayout(oldLayout)
    }
    
    override public func finalizeLayoutTransition() {
        previousContentOffset = nil
        
        super.finalizeLayoutTransition()
    }
        
}
