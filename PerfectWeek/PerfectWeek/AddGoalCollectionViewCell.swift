//
//  AddGoalCollectionViewCell.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalCollectionViewCell: UICollectionViewCell {

	static let size = CGSize(width: UIScreen.main.bounds.size.width - (collectionViewInset * 4), height: 64.0)

	let newGoalButton: UIButton = {
		let button = UIButton(style: .custom)
		button.setTitle("New Goal", for: .normal)
		return button
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		addSubview(newGoalButton)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		newGoalButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			newGoalButton.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			newGoalButton.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
			newGoalButton.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			newGoalButton.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor)
		])
	}
}
