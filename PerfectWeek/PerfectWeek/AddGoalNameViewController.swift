//
//  AddGoalNameViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/5/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalNameViewController: UIViewController {

	var viewModel: AddGoalNameViewModel!
	private let nextButton = UIButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.title = "Add A Goal"
		setupNameLabel()
		setupNameTextField()
		setupNextButton()
	}

	private func setupNameLabel() {
		let nameLabel = Label(style: .body)
		nameLabel.text = "Enter a name for your goal"
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive  = true
		nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-height).isActive = true
	}

	private func setupNameTextField() {
		let nameTextField = UITextField()
		nameTextField.delegate = self
		nameTextField.borderStyle = .line
		view.addSubview(nameTextField)

		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: height).isActive = true
	}

	private func setupNextButton() {
		nextButton.setTitle("Next", for: .normal)
		nextButton.backgroundColor = .purple
		nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
		view.addSubview(nextButton)

		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
		nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}

	// MARK: - Navigation
	func next(_ nextButton: UIButton) {
		let addGoalTypeVC = AddGoalTypeViewController()
		addGoalTypeVC.viewModel = AddGoalTypeViewModel(mutableGoal: viewModel.mutableGoal)
		navigationController?.pushViewController(addGoalTypeVC, animated: true)
	}
}

extension AddGoalNameViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		viewModel.mutableGoal.name = textField.text
		return textField.resignFirstResponder()
	}

}
