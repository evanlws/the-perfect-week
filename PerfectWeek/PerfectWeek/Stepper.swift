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
	weak var delegate: StepperDelegate?

	init() {
		super.init(frame: .zero)
		backgroundColor = .purple
		configureViews()
	}

	private func configureViews() {
		numberLabel.text = String(counter)
		numberLabel.font = UIFont.systemFont(ofSize: 28)
		numberLabel.textColor = ColorLibrary.UIPalette.primary
		numberLabel.backgroundColor = .white
		numberLabel.layer.borderColor = UIColor.black.cgColor
		numberLabel.layer.borderWidth = 1
		numberLabel.textAlignment = .center

		let plusButton = UIButton()
		plusButton.setTitle("+", for: .normal)
		plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
		plusButton.backgroundColor = .white
		plusButton.layer.borderColor = UIColor.black.cgColor
		plusButton.layer.borderWidth = 1
		plusButton.setTitleColor(ColorLibrary.UIPalette.primary, for: .normal)
		plusButton.addTarget(self, action: #selector(increment), for: .touchUpInside)

		let minusButton = UIButton()
		minusButton.setTitle("-", for: .normal)
		minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
		minusButton.backgroundColor = .white
		minusButton.layer.borderColor = UIColor.black.cgColor
		minusButton.layer.borderWidth = 1
		minusButton.setTitleColor(ColorLibrary.UIPalette.primary, for: .normal)
		minusButton.addTarget(self, action: #selector(decrement), for: .touchUpInside)

		let stepperStackView = UIStackView(arrangedSubviews: [plusButton, minusButton])
		stepperStackView.axis = .vertical
		stepperStackView.distribution = .fillEqually

		let containerStackView = UIStackView(arrangedSubviews: [numberLabel, stepperStackView])
		containerStackView.axis = .horizontal
		containerStackView.distribution = .fillEqually
		addSubview(containerStackView)

		containerStackView.translatesAutoresizingMaskIntoConstraints = false
		containerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		containerStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		containerStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
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
