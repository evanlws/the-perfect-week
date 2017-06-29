//
//  Stepper.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/14/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

protocol StepperDelegate: class {
	func valueChanged(_ value: Int)
}

final class Stepper: UIView {

	var maxValue = 7
	var minValue = 1

	var counter: Int = 1 {
		didSet {
			numberLabel.text = String(counter)
		}
	}

	private let numberLabel = UILabel()
	private let plusButton = UIButton()
	private let minusButton = UIButton()
	private let verticalSpacer = UIView()
	private let horizontalSpacer = UIView()
	private let backgroundView = UIView()

	weak var delegate: StepperDelegate?

	init() {
		super.init(frame: .zero)
		configureViews()
		configureConstraints()
	}

	private func configureViews() {
		numberLabel.text = String(counter)
		numberLabel.font = UIFont.systemFont(ofSize: 28)
		numberLabel.textColor = ColorLibrary.UIPalette.primary
		numberLabel.textAlignment = .center

		plusButton.setTitle("+", for: .normal)
		plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
		plusButton.setTitleColor(ColorLibrary.UIPalette.primary, for: .normal)
		plusButton.addTarget(self, action: #selector(increment), for: .touchUpInside)

		minusButton.setTitle("-", for: .normal)
		minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
		minusButton.setTitleColor(ColorLibrary.UIPalette.primary, for: .normal)
		minusButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)

		verticalSpacer.backgroundColor = ColorLibrary.BlackAndWhite.black
		horizontalSpacer.backgroundColor = ColorLibrary.BlackAndWhite.black

		backgroundView.backgroundColor = ColorLibrary.BlackAndWhite.white
		backgroundView.layer.borderWidth = 1
		backgroundView.layer.borderColor = ColorLibrary.BlackAndWhite.black.cgColor
		backgroundView.layer.cornerRadius = Constraints.gridBlock

		addSubview(backgroundView)
		addSubview(numberLabel)
		addSubview(plusButton)
		addSubview(minusButton)
		addSubview(horizontalSpacer)
		addSubview(verticalSpacer)
	}

	private func configureConstraints() {
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		numberLabel.translatesAutoresizingMaskIntoConstraints = false
		plusButton.translatesAutoresizingMaskIntoConstraints = false
		minusButton.translatesAutoresizingMaskIntoConstraints = false
		horizontalSpacer.translatesAutoresizingMaskIntoConstraints = false
		verticalSpacer.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			backgroundView.topAnchor.constraint(equalTo: topAnchor),
			backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
			backgroundView.leftAnchor.constraint(equalTo: leftAnchor),
			backgroundView.rightAnchor.constraint(equalTo: rightAnchor),

			verticalSpacer.topAnchor.constraint(equalTo: topAnchor),
			verticalSpacer.bottomAnchor.constraint(equalTo: bottomAnchor),
			verticalSpacer.widthAnchor.constraint(equalToConstant: 1.0),
			verticalSpacer.centerXAnchor.constraint(equalTo: centerXAnchor),

			horizontalSpacer.leftAnchor.constraint(equalTo: verticalSpacer.rightAnchor),
			horizontalSpacer.rightAnchor.constraint(equalTo: rightAnchor),
			horizontalSpacer.heightAnchor.constraint(equalToConstant: 1.0),
			horizontalSpacer.centerYAnchor.constraint(equalTo: centerYAnchor),

			numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 2.0),
			numberLabel.rightAnchor.constraint(equalTo: verticalSpacer.leftAnchor, constant: 2.0),
			numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
			numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0),

			plusButton.leftAnchor.constraint(equalTo: verticalSpacer.rightAnchor, constant: 2.0),
			plusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2.0),
			plusButton.topAnchor.constraint(equalTo: topAnchor, constant: 2.0),
			plusButton.bottomAnchor.constraint(equalTo: horizontalSpacer.topAnchor, constant: -2.0),

			minusButton.leftAnchor.constraint(equalTo: verticalSpacer.rightAnchor, constant: 2.0),
			minusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -2.0),
			minusButton.topAnchor.constraint(equalTo: horizontalSpacer.bottomAnchor, constant: 2.0),
			minusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2.0)
		])
	}

	func increment() {
		if counter != maxValue {
			counter += 1
			numberLabel.text = String(counter)
			delegate?.valueChanged(counter)
		}
	}

	func decrement() {
		if counter != minValue {
			counter -= 1
			numberLabel.text = String(counter)
			delegate?.valueChanged(counter)
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
