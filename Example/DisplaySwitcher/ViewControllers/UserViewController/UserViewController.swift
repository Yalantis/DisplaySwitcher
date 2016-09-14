//
//  UserViewController.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DisplaySwitcher

private let animationDuration: TimeInterval = 0.3

private let listLayoutStaticCellHeight: CGFloat = 80
private let gridLayoutStaticCellHeight: CGFloat = 165

class UserViewController: UIViewController {
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet fileprivate weak var rotationButton: RotationButton!
    
    fileprivate var tap: UITapGestureRecognizer!
    fileprivate var users = UserDataProvider().generateFakeUsers()
    fileprivate var searchUsers = [User]()
    fileprivate var isTransitionAvailable = true
    fileprivate lazy var listLayout = BaseLayout(staticCellHeight: listLayoutStaticCellHeight, nextLayoutStaticCellHeight: gridLayoutStaticCellHeight, layoutState: .list)
    fileprivate lazy var gridLayout = BaseLayout(staticCellHeight: gridLayoutStaticCellHeight, nextLayoutStaticCellHeight: listLayoutStaticCellHeight, layoutState: .grid)
    fileprivate var layoutState: CollectionViewLayoutState = .list
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        searchUsers = users
        rotationButton.isSelected = true
        setupCollectionView()
    }
    
    // MARK: - Private methods
    fileprivate func setupCollectionView() {
        collectionView.collectionViewLayout = listLayout
        collectionView.register(UserCollectionViewCell.cellNib, forCellWithReuseIdentifier:UserCollectionViewCell.id)
    }
    
    // MARK: - Actions
    @IBAction func buttonTapped(_ sender: AnyObject) {
        if !isTransitionAvailable {
            return
        }
        let transitionManager: TransitionManager
        if layoutState == .list {
            layoutState = .grid
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: gridLayout, layoutState: layoutState)
        } else {
            layoutState = .list
            transitionManager = TransitionManager(duration: animationDuration, collectionView: collectionView!, destinationLayout: listLayout, layoutState: layoutState)
        }
        transitionManager.startInteractiveTransition()
        rotationButton.isSelected = layoutState == .list
        rotationButton.animationDuration = animationDuration
    }
    
    @IBAction func tapRecognized() {
        view.endEditing(true)
    }

}

extension UserViewController {
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.id, for: indexPath) as! UserCollectionViewCell
        if layoutState == .grid {
            cell.setupGridLayoutConstraints(1, cellWidth: cell.frame.width)
        } else {
            cell.setupListLayoutConstraints(1, cellWidth: cell.frame.width)
        }
        cell.bind(searchUsers[(indexPath as NSIndexPath).row])
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        let customTransitionLayout = TransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
        return customTransitionLayout
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isTransitionAvailable = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isTransitionAvailable = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
}

extension UserViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchUsers = users
        } else {
            searchUsers = searchUsers.filter { return $0.name.contains(searchText) }
        }
      
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView,didSelectItemAtIndexPath indexPath: IndexPath) {
        print("Hi \((indexPath as NSIndexPath).row)")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tap)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tap)
    }
    
    func handleTap() {
        view.endEditing(true)
    }
    
}
    
