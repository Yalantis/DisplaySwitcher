//
//  TransitionManager.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

private let finishTransitionValue = 1.0

public class TransitionManager {
    
    private var duration: NSTimeInterval
    private var collectionView: UICollectionView
    private var destinationLayout: UICollectionViewLayout
    private var layoutState: CollectionViewLayoutState
    private var transitionLayout: TransitionLayout!
    private var updater: CADisplayLink!
    private var start: NSTimeInterval!
    
    // MARK: - Lifecycle
    public init(duration: NSTimeInterval, collectionView: UICollectionView, destinationLayout: UICollectionViewLayout, layoutState: CollectionViewLayoutState) {
        self.collectionView = collectionView
        self.destinationLayout = destinationLayout
        self.layoutState = layoutState
        self.duration = duration
    }
    
    // MARK: - Public methods
    public func startInteractiveTransition() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        transitionLayout = collectionView.startInteractiveTransitionToCollectionViewLayout(destinationLayout, completion: { success, finish in
            if success && finish {
                self.collectionView.reloadData()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
            }
        }) as! TransitionLayout
        transitionLayout.layoutState = layoutState
        createUpdaterAndStart()
    }
    
    // MARK: - Private methods
    private func createUpdaterAndStart() {
        start = CACurrentMediaTime()
        updater = CADisplayLink(target: self, selector: Selector("updateTransitionProgress"))
        updater.frameInterval = 1
        updater.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSRunLoopCommonModes)
    }
    
    dynamic func updateTransitionProgress() {
        var progress = (updater.timestamp - start) / duration
        progress = min(1, progress)
        progress = max(0, progress)
        transitionLayout.transitionProgress = CGFloat(progress)
      
        transitionLayout.invalidateLayout()
        if progress == finishTransitionValue {
            collectionView.finishInteractiveTransition()
            updater.invalidate()
        }
    }
}