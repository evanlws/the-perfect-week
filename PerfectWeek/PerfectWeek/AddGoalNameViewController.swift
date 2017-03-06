//
//  AddGoalNameViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/5/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class AddGoalNameViewController: UIViewController {

	var dataSource: AddGoalNameViewModel
	let nextButton = UIButton()

	init() {
		self.dataSource = AddGoalNameViewModel()
		super.init(nibName: nil, bundle: nil)
		self.view.backgroundColor = .white
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Add A Goal"
		setupNameLabel()
		setupNameTextField()
		setupNextButton()
	}

	fileprivate func setupNameLabel() {
		let nameLabel = UILabel()
		nameLabel.text = "Enter a name for your goal"
		nameLabel.font = UIFont.systemFont(ofSize: 21)
		nameLabel.minimumScaleFactor = 0.6
		nameLabel.textColor = .black
		nameLabel.textAlignment = .center
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive  = true
		nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-height).isActive = true
	}

	fileprivate func setupNameTextField() {
		let nameTextField = UITextField()
		nameTextField.delegate = self
		nameTextField.tag = 1
		nameTextField.borderStyle = .line
		view.addSubview(nameTextField)

		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: height).isActive = true
	}

	fileprivate func setupNextButton() {
		nextButton.setTitle("Next", for: .normal)
		nextButton.backgroundColor = .purple
		nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
		nextButton.isEnabled = false
		view.addSubview(nextButton)

		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
		nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}

	// MARK: - Navigation
	func next(_ sender: UIButton) {
		dataSource.setGoalName()
		dismiss(animated: true, completion: nil)
	}
}

extension AddGoalNameViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard textField.tag == 1 else { return resignFirstResponder() }

		if dataSource.validateGoalName(goalName: textField.text) {
			nextButton.isEnabled = true
		} else {
			nextButton.isEnabled = false
		}

		return textField.resignFirstResponder()
	}

}
