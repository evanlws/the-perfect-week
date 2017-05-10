//
//  GoalCollectionViewCell.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalCollectionViewCell: UICollectionViewCell {

	static let size = CGSize(width: UIScreen.main.bounds.size.width - (collectionViewInset * 4), height: 64.0)

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
		backgroundColor = .white
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0, height: 1)
		layer.shadowOpacity = 1
		layer.shadowRadius = 1.0
		clipsToBounds = false
		layer.masksToBounds = false
		addSubview(nameLabel)
		addSubview(progressView)

		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
		nameLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
		nameLabel.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true

		progressView.translatesAutoresizingMaskIntoConstraints = false
		progressView.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
		progressView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
		progressView.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
		progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor).isActive = true
		progressView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
	}

}
