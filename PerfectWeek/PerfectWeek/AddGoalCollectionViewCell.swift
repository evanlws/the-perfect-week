//
//  AddGoalCollectionViewCell.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalCollectionViewCell: UICollectionViewCell {

	static let size = CGSize(width: UIScreen.main.bounds.size.width - (collectionViewInset * 3), height: Constraints.gridBlock * 4)

	let newGoalButton: UIButton = {
		let button = Button.initialize(type: .basicBox)
		button.setTitle(LocalizedStrings.newGoal, for: .normal)
		return button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
		configureConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureViews() {
		addSubview(newGoalButton)
	}

	private func configureConstraints() {
		newGoalButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			newGoalButton.topAnchor.constraint(equalTo: contentView.topAnchor),
			newGoalButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			newGoalButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			newGoalButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
		])
	}
}
