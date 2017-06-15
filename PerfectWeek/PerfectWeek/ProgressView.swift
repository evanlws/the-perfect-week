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

	private var progressBar = UIView()
	private var heightConstraint: NSLayoutConstraint?
	var height: CGFloat?

	override init(frame: CGRect) {
		super.init(frame: frame)

		backgroundColor = ColorLibrary.UIPalette.accent
		clipsToBounds = true
		progressBar.backgroundColor = .green
		addSubview(progressBar)
		addSubview(progressLabel)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		progressLabel.translatesAutoresizingMaskIntoConstraints = false
		progressBar.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			progressLabel.topAnchor.constraint(equalTo: topAnchor),
			progressLabel.leftAnchor.constraint(equalTo: leftAnchor),
			progressLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			progressLabel.rightAnchor.constraint(equalTo: rightAnchor),
			progressBar.topAnchor.constraint(equalTo: topAnchor),
			progressBar.leftAnchor.constraint(equalTo: leftAnchor),
			progressBar.rightAnchor.constraint(equalTo: rightAnchor)
		])

		heightConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 0.0)
		progressBar.addConstraint(heightConstraint!)
	}

	func updateProgress(progress: Int) {
		guard let height = height, height > 0 else { fatalError(guardFailureWarning("Height is 0")) }
		progressLabel.text = "\(progress)%"
		UIView.animate(withDuration: 1) {
			self.heightConstraint?.constant = CGFloat(progress) / 100 * height
			self.layoutIfNeeded()
		}
	}

}
