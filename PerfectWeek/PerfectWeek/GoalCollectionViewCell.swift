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
		label.textColor = .purple
		label.textAlignment = .left
		label.numberOfLines = 4
		return label
	}()

	private var progressLabel: UILabel = {
		let label = UILabel()
		label.text = "0%"
		label.font = UIFont.systemFont(ofSize: 16.0)
		label.textAlignment = .center
		return label
	}()

	private let progressView = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .white
		contentView.layer.borderColor = UIColor.purple.cgColor
		contentView.layer.borderWidth = 2.0
		addSubview(nameLabel)

		progressView.addSubview(progressLabel)
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

		progressLabel.translatesAutoresizingMaskIntoConstraints = false
		progressLabel.topAnchor.constraint(equalTo: progressView.topAnchor).isActive = true
		progressLabel.leftAnchor.constraint(equalTo: progressView.leftAnchor).isActive = true
		progressLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true
		progressLabel.rightAnchor.constraint(equalTo: progressView.rightAnchor).isActive = true
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

	func setProgress(value: Int) {
		var value = value
		if value > 100 {
			value = 100
		} else if value < 0 {
			value = 0
		}

		progressLabel.text = "\(value)%"
	}

}
