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
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var backgroundGradientView: UIView!
    @IBOutlet private weak var nameListLabel: UILabel!
    @IBOutlet private weak var nameGridLabel: UILabel!
    @IBOutlet weak var statisticLabel: UILabel!
    
    // avatarImageView constraints
    @IBOutlet private weak var avatarImageViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var avatarImageViewHeightConstraint: NSLayoutConstraint!
    
    // nameListLabel constraints
    @IBOutlet var nameListLabelLeadingConstraint: NSLayoutConstraint! {
        didSet {
            initialLabelsLeadingConstraintValue = nameListLabelLeadingConstraint.constant
        }
    }
    
    // statisticLabel constraints
    @IBOutlet weak var statisticLabelLeadingConstraint: NSLayoutConstraint!
    
    private var avatarGridLayoutSize: CGFloat = 0.0
    private var initialLabelsLeadingConstraintValue: CGFloat = 0.0
    
    func bind(user: User) {
        avatarImageView.image = user.avatar
        nameListLabel.text = user.name.localized + " " + user.surname.localized
        nameGridLabel.text = nameListLabel.text
        let userPostsString = (String(user.postsCount) + " posts • ").localized
        let userCommentsString = (String(user.commentsCount) + " comments • ").localized
        let userLikesString = (String(user.likesCount) + " likes").localized
        statisticLabel.text = userPostsString + userCommentsString + userLikesString
    }
    
    func setupGridLayoutConstraints(transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil((cellWidth - avatarListLayoutSize) * transitionProgress + avatarListLayoutSize)
        avatarImageViewWidthConstraint.constant = ceil(avatarImageViewHeightConstraint.constant)
        nameListLabelLeadingConstraint.constant = -avatarImageViewWidthConstraint.constant * transitionProgress + initialLabelsLeadingConstraintValue
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = 1 - transitionProgress
        statisticLabel.alpha = 1 - transitionProgress
    }
    
    func setupListLayoutConstraints(transitionProgress: CGFloat, cellWidth: CGFloat) {
        avatarImageViewHeightConstraint.constant = ceil(avatarGridLayoutSize - (avatarGridLayoutSize - avatarListLayoutSize) * transitionProgress)
        avatarImageViewWidthConstraint.constant = avatarImageViewHeightConstraint.constant 
        nameListLabelLeadingConstraint.constant = avatarImageViewWidthConstraint.constant * transitionProgress + (initialLabelsLeadingConstraintValue - avatarImageViewHeightConstraint.constant)
        statisticLabelLeadingConstraint.constant = nameListLabelLeadingConstraint.constant
        backgroundGradientView.alpha = transitionProgress <= 0.5 ? 1 - transitionProgress : transitionProgress
        nameListLabel.alpha = transitionProgress
        statisticLabel.alpha = transitionProgress
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        if let attributes = layoutAttributes as? BaseLayoutAttributes {
            if attributes.transitionProgress > 0 {
                if attributes.layoutState == .GridLayoutState {
                    setupGridLayoutConstraints(attributes.transitionProgress, cellWidth: CGRectGetWidth(attributes.nextLayoutCellFrame))
                    avatarGridLayoutSize = CGRectGetWidth(attributes.nextLayoutCellFrame)
                } else {
                    setupListLayoutConstraints(attributes.transitionProgress, cellWidth: CGRectGetWidth(attributes.nextLayoutCellFrame))
                }
            }
        }
    }
}
