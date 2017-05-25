//
//  ProgressView.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class ProgressView: UIView {

	private var progressLabel: UILabel = {
		let label = UILabel()
		label.text = "0%"
		label.font = UIFont.systemFont(ofSize: 16.0)
		label.textColor = .white
		label.textAlignment = .center
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = ColorLibrary.UIPalette.accent
		addSubview(progressLabel)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		progressLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			progressLabel.topAnchor.constraint(equalTo: topAnchor),
			progressLabel.leftAnchor.constraint(equalTo: leftAnchor),
			progressLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			progressLabel.rightAnchor.constraint(equalTo: rightAnchor)
		])
	}

	func updateProgress(progress: Int) {
		progressLabel.text = "\(progress)%"
	}

}
