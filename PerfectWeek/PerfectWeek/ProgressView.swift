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
	private var progress: CGFloat = 0.0
	var height: CGFloat

	init(height: CGFloat) {
		self.height = height
		super.init(frame: .zero)
		backgroundColor = ColorLibrary.UIPalette.accent
		clipsToBounds = true
		layer.cornerRadius = height / 2

		circleOutline.backgroundColor = .clear
		circleOutline.layer.borderColor = ColorLibrary.BlackAndWhite.gray1.cgColor
		circleOutline.layer.borderWidth = 1.0
		circleOutline.layer.cornerRadius = height / 2

		gradientLayer.frame = CGRect(x: 0, y: 0, width: height, height: height)
		gradientLayer.colors = [ColorLibrary.UIPalette.accent.cgColor, ColorLibrary.UIPalette.primary.cgColor]
		layer.insertSublayer(gradientLayer, at: 0)
		addSubview(progressBar)

		progressBar.backgroundColor = .white
		progressBar.addSubview(circleOutline)
		progressBar.clipsToBounds = true

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

	func updateProgress(progress: CGFloat, animated: Bool, completion: @escaping () -> Void) {
		guard height > 0 else {
			print("View is trying to update but the frame is 0")
			return
		}

		if animated {
			UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut, animations: {
				self.heightConstraint?.constant = self.height - (progress / 100 * self.height)
				self.layoutIfNeeded()
			}, completion: { _ in
				completion()
			})
		} else {
			heightConstraint?.constant = height - (progress / 100 * height)
		}
	}

}
