//
//  GoalsCollectionViewHeader.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class GoalsCollectionViewHeader: UICollectionReusableView {

	let nameLabel = Label(style: .body4, color: ColorLibrary.BlackAndWhite.gray2)

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
			nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - (collectionViewInset * 3)),
			nameLabel.heightAnchor.constraint(equalToConstant: Constraints.gridBlock * 2),
			nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}

}
