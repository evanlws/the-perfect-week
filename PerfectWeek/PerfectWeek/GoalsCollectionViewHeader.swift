//
//  GoalsCollectionViewHeader.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class GoalsCollectionViewHeader: UICollectionReusableView {

	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14.0)
		label.minimumScaleFactor = 0.6
		label.textColor = .gray
		label.textAlignment = .left
		label.numberOfLines = 4
		return label
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
		addSubview(nameLabel)
	}

	private func configureConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			nameLabel.widthAnchor.constraint(equalTo: widthAnchor),
			nameLabel.heightAnchor.constraint(equalTo: heightAnchor)
			])
	}

}
