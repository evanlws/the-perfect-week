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
	fileprivate let nextButton = UIButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
		navigationItem.leftBarButtonItem = cancelButtonItem
		self.view.backgroundColor = .white
		self.title = "Add Goal"
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
		nameTextField.autocorrectionType = .no
		nameTextField.returnKeyType = .done
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
		disableNextButton()
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
		nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
		nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}

}

// MARK: - Navigation
extension AddGoalNameViewController {
	func next(_ nextButton: UIButton) {
		let addGoalFrequencyVC = AddGoalFrequencyViewController()
		addGoalFrequencyVC.viewModel = AddGoalFrequencyViewModel(mutableGoal: viewModel.mutableGoal)
		navigationController?.pushViewController(addGoalFrequencyVC, animated: true)
	}

	func cancel(_ cancelBarButtonItem: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

	fileprivate func disableNextButton() {
		nextButton.alpha = 0.5
		nextButton.isEnabled = false
	}

	fileprivate func enableNextButton() {
		nextButton.alpha = 1.0
		nextButton.isEnabled = true
	}
}

extension AddGoalNameViewController: UITextFieldDelegate {

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.text?.isBlank == false {
			viewModel.mutableGoal.name = textField.text
			enableNextButton()
		}
	}

	// String == What the user is trying to add
	// Text == What the user already had
	// Updated text == What the user has altogether. Should be String + text if succeeds
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard let text = textField.text, let stringRange = range.range(for: text) else {
			return false
		}

		if !string.isEmpty, String(string.characters.prefix(1)).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, text.isEmpty || (text.isBlank && string.isBlank) {
			return false
		}

		let updatedText = text.replacingCharacters(in: stringRange, with: string)

		if string.isEmpty {
			return true //backspace
		}

		return updatedText.characters.count <= 30
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.resignFirstResponder()
	}

}
