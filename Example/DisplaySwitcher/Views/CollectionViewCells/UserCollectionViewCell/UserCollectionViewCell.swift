//
//  UserCollectionViewCell.swift
//  YALLayoutTransitioning
//
//  Created by Roman on 23.02.16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit
import DisplaySwitcher

private let avatarListLayoutSize: CGFloat = 80.0

class UserCollectionViewCell: UICollectionViewCell, CellInterface {
    
    @IBOutlet fileprivate weak var avatarImageView: UIImageView!
    @IBOutlet fileprivate weak var backgroundGradientView: UIView!
    @IBOutlet fileprivate weak var nameListLabel: UILabel!
    @IBOutlet fileprivate weak var nameGridLabel: UILabel!
    @IBOutlet weak var statisticLabel: UILabel!
    
    // avatarImageView constraints
    @IBOutlet fileprivate weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var avatarImageViewHeightConstraint: NSLayoutConstraint!
    
    // nameListLabel constraints
    @IBOutlet var nameListLabelLeadingConstraint: NSLayoutConstraint! {
        didSet {
            initialLabelsLeadingConstraintValue = nameListLabelLeadingConstraint.constant
        }
    }
    
    // statisticLabel constraints
    @IBOutlet weak var statisticLabelLeadingConstraint: NSLayoutConstraint!
    
    fileprivate var avatarGridLayoutSize: CGFloat = 0.0
    fileprivate var initialLabelsLeadingConstraintValue: CGFloat = 0.0
    
    func bind(_ user: User) {
        avatarImageView.image = user.avatar
        nameListLabel.text = user.name.localized + " " + user.surname.localized
        nameGridLabel.text = nameListLabel.text
        let userPostsString = (String(user.postsCount) + " posts • ").localized
        let userCommentsString = (String(user.commentsCount) + " comments • ").localized
        let userLikesString = (String(user.likesCount) + " likes").localized
        statisticLabel.text = userPostsString + userCommentsString + userLikesString
    }
    
    func setupGridLayoutConstraints(_ transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil((cellWidth - avatarListLayoutSize) * transitionProgress + avatarListLayoutSize)
        avatarImageViewWidthConstraint.constant = ceil(avatarImageViewHeightConstraint.constant)
        nameListLabelLeadingConstraint.constant = -avatarImageViewWidthConstraint.constant * transitionProgress + initialLabelsLeadingConstraintValue
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = 1 - transitionProgress
        statisticLabel.alpha = 1 - transitionProgress
    }
    
    func setupListLayoutConstraints(_ transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil(avatarGridLayoutSize - (avatarGridLayoutSize - avatarListLayoutSize) * transitionProgress)
        avatarImageViewWidthConstraint.constant = avatarImageViewHeightConstraint.constant 
        nameListLabelLeadingConstraint.constant = avatarImageViewWidthConstraint.constant * transitionProgress + (initialLabelsLeadingConstraintValue - avatarImageViewHeightConstraint.constant)
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = transitionProgress
        statisticLabel.alpha = transitionProgress
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? DisplaySwitchLayoutAttributes {
            if attributes.transitionProgress > 0 {
                if attributes.layoutState == .grid {
                    setupGridLayoutConstraints(attributes.transitionProgress, cellWidth: attributes.nextLayoutCellFrame.width)
                    avatarGridLayoutSize = attributes.nextLayoutCellFrame.width
                } else {
                    setupListLayoutConstraints(attributes.transitionProgress, cellWidth: attributes.nextLayoutCellFrame.width)
                }
            }
        }
    }
}
