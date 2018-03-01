//
//  DisplaySwitchLayout.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 29.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

@objc public enum LayoutState: Int {
    
    case list, grid

}

open class DisplaySwitchLayout: UICollectionViewLayout {
    
    fileprivate let numberOfColumns: Int
    fileprivate let cellPadding: CGPoint
    fileprivate let staticCellHeight: CGFloat
    fileprivate let nextLayoutStaticCellHeight: CGFloat
    fileprivate var previousContentOffset: NSValue?
    public let layoutState: LayoutState
    fileprivate let listLayoutCountOfColumns = 1
    fileprivate let gridLayoutCountOfColumns: Int
  
    fileprivate var baseLayoutAttributes: [DisplaySwitchLayoutAttributes]!
    
    fileprivate var contentHeight: CGFloat = 0.0
    fileprivate var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - insets.left - insets.right
    }
    
    // MARK: - Lifecycle
  
    public init(staticCellHeight: CGFloat, nextLayoutStaticCellHeight: CGFloat, layoutState: LayoutState,
                cellPadding: CGPoint = CGPoint(x: 6, y: 6), gridLayoutCountOfColumns: Int = 3) {
        self.staticCellHeight = staticCellHeight
        self.gridLayoutCountOfColumns = gridLayoutCountOfColumns
        self.numberOfColumns = layoutState == .list ? listLayoutCountOfColumns : gridLayoutCountOfColumns
        self.layoutState = layoutState
        self.nextLayoutStaticCellHeight = nextLayoutStaticCellHeight
        self.cellPadding = cellPadding
        
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UICollectionViewLayout
  
    override open func prepare() {
        super.prepare()
        
        baseLayoutAttributes = [DisplaySwitchLayoutAttributes]()
        
        // cells layout
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffsets = [CGFloat]()
        for column in 0 ..< numberOfColumns {
            xOffsets.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset = [CGFloat](repeating: contentHeight, count: numberOfColumns)
        for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)
            let height = cellPadding.y + staticCellHeight
            let frame = CGRect(x: xOffsets[column], y: yOffset[column], width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: cellPadding.x, dy: cellPadding.y)
            let attributes = DisplaySwitchLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            baseLayoutAttributes.append(attributes)
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height
            column = column == (numberOfColumns - 1) ? 0 : column + 1
        }
    }
    
    override open var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = baseLayoutAttributes.filter { $0.frame.intersects(rect) }
        
        return layoutAttributes
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return baseLayoutAttributes[indexPath.row]
    }
    
    override open class var layoutAttributesClass: AnyClass {
        return DisplaySwitchLayoutAttributes.self
    }
    
    // Fix bug with content offset
    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let previousContentOffsetPoint = previousContentOffset?.cgPointValue
        let superContentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        if let previousContentOffsetPoint = previousContentOffsetPoint {
            if previousContentOffsetPoint.y == 0 {
                return previousContentOffsetPoint
            }
            if layoutState == LayoutState.list {
                let offsetY = ceil(previousContentOffsetPoint.y + (staticCellHeight * previousContentOffsetPoint.y / nextLayoutStaticCellHeight) + cellPadding.y)
                return CGPoint(x: superContentOffset.x, y: offsetY)
            } else {
                let realOffsetY = ceil((previousContentOffsetPoint.y / nextLayoutStaticCellHeight * staticCellHeight / CGFloat(numberOfColumns)) - cellPadding.y)
                let offsetY = floor(realOffsetY / staticCellHeight) * staticCellHeight + cellPadding.y
                return CGPoint(x: superContentOffset.x, y: offsetY)
            }
        }
        
        return superContentOffset
    }
    
    override open func prepareForTransition(from oldLayout: UICollectionViewLayout) {
        previousContentOffset = NSValue(cgPoint: collectionView!.contentOffset)
        
        return super.prepareForTransition(from: oldLayout)
    }
    
    override open func finalizeLayoutTransition() {
        previousContentOffset = nil
        
        super.finalizeLayoutTransition()
    }
        
}
