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
		setupStackViews()
	}

	private func setupStackViews() {
		numberLabel.text = String(counter)
		numberLabel.font = UIFont.systemFont(ofSize: 28)
		numberLabel.textColor = .white
		numberLabel.backgroundColor = .orange
		numberLabel.textAlignment = .center

		let plusButton = UIButton()
		plusButton.setTitle("+", for: .normal)
		plusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
		plusButton.backgroundColor = .green
		plusButton.tintColor = .white
		plusButton.addTarget(self, action: #selector(increment), for: .touchUpInside)

		let minusButton = UIButton()
		minusButton.setTitle("-", for: .normal)
		minusButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
		minusButton.backgroundColor = .green
		minusButton.tintColor = .blue
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
		if counter != 7 {
			counter += 1
			numberLabel.text = String(counter)
			delegate?.valueChanged(counter)
		}
	}

	func decrement() {
		if counter != 0 {
			counter -= 1
			numberLabel.text = String(counter)
			delegate?.valueChanged(counter)
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
