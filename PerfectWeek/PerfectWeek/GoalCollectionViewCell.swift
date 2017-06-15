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

	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 24.0)
		label.minimumScaleFactor = 0.6
		label.textAlignment = .left
		label.numberOfLines = 4
		return label
	}()

	let progressView = ProgressView()

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
		let progressViewWidth: CGFloat = 50.0

		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
			nameLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor),
			nameLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
			progressView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
			progressView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor),
			progressView.widthAnchor.constraint(equalToConstant: progressViewWidth),
			progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor),
			progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		])

		progressView.layer.cornerRadius = progressViewWidth / 2
	}

}
