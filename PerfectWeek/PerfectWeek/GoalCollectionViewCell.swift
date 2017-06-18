//
//  GoalCollectionViewCell.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalCollectionViewCell: UICollectionViewCell {

	static let size = CGSize(width: UIScreen.main.bounds.size.width - (collectionViewInset * 3), height: Constraints.gridBlock * 8)

	let nameLabel: Label = {
		let label = Label(style: .body2)
		label.numberOfLines = 4
		return label
	}()

	let progressView = ProgressView(height: Constraints.gridBlock * 6)

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
		configureConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureViews() {
		backgroundColor = .white
		layer.shadowColor = UIColor.black.cgColor
		layer.cornerRadius = Constraints.gridBlock
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowOpacity = 1
		layer.shadowRadius = 1.5
		clipsToBounds = false
		layer.masksToBounds = false

		addSubview(nameLabel)
		addSubview(progressView)
	}

	private func configureConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		progressView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constraints.gridBlock),
			nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressView.leadingAnchor),
			nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

			progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constraints.gridBlock),
			progressView.heightAnchor.constraint(equalToConstant: progressView.height),
			progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),
			progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])
	}

}
