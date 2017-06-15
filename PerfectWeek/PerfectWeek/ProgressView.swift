//
//  ProgressView.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class ProgressView: UIView {

	private var progressBar = UIView()
	private var circleOutline = UIView()
	private let gradientLayer = CAGradientLayer()
	private var heightConstraint: NSLayoutConstraint?
	let height: CGFloat

	init(frame: CGRect, height: CGFloat) {
		self.height = height
		super.init(frame: frame)

		backgroundColor = ColorLibrary.UIPalette.accent
		clipsToBounds = true
		progressBar.backgroundColor = .white
		circleOutline.backgroundColor = .clear
		circleOutline.layer.borderColor = UIColor.gray.cgColor
		circleOutline.layer.borderWidth = 1.0
		circleOutline.layer.cornerRadius = height / 2
		progressBar.addSubview(circleOutline)
		progressBar.clipsToBounds = true
		gradientLayer.frame = CGRect(x: 0, y: 0, width: height, height: height)
		gradientLayer.colors = [ColorLibrary.UIPalette.accent.cgColor, ColorLibrary.UIPalette.primary.cgColor]
		layer.insertSublayer(gradientLayer, at: 0)
		addSubview(progressBar)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		progressBar.translatesAutoresizingMaskIntoConstraints = false
		circleOutline.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			circleOutline.topAnchor.constraint(equalTo: topAnchor),
			circleOutline.leftAnchor.constraint(equalTo: leftAnchor),
			circleOutline.bottomAnchor.constraint(equalTo: bottomAnchor),
			circleOutline.rightAnchor.constraint(equalTo: rightAnchor),
			progressBar.topAnchor.constraint(equalTo: topAnchor),
			progressBar.leftAnchor.constraint(equalTo: leftAnchor),
			progressBar.rightAnchor.constraint(equalTo: rightAnchor)
		])

		heightConstraint = NSLayoutConstraint(item: progressBar, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 0.0)
		progressBar.addConstraint(heightConstraint!)
	}

	func updateProgress(progress: Int) {
		guard height > 0 else { fatalError(guardFailureWarning("Height is 0")) }
		UIView.animate(withDuration: 1) {
			self.heightConstraint?.constant = self.height - (CGFloat(progress) / 100 * self.height)
			self.layoutIfNeeded()
		}
	}

}
