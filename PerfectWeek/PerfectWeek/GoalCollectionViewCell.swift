//
//  GoalCollectionViewCell.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalCollectionViewCell: UICollectionViewCell {

	static let size: CGSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 64.0)

	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24.0)
		label.minimumScaleFactor = 0.6
		label.textColor = .purple
		label.textAlignment = .left
		label.numberOfLines = 4
		return label
	}()

	convenience init() {
		self.init(frame: CGRect(x: 0, y: 0, width: 170, height: 125))
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		contentView.layer.borderColor = UIColor.purple.cgColor
		contentView.layer.borderWidth = 2.0
		addSubview(nameLabel)
		setupNameLabel()
	}

	func setCompletedStyle(_ isCompleted: Bool) {
		if isCompleted {
			backgroundColor = .purple
			nameLabel.textColor = .white
			contentView.layer.borderWidth = 0.0
		} else {
			backgroundColor = .white
			nameLabel.textColor = .purple
			contentView.layer.borderColor = UIColor.purple.cgColor
			contentView.layer.borderWidth = 2.0
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupNameLabel() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 5).isActive = true
		nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -5).isActive = true
		nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor).isActive = true
	}

}
