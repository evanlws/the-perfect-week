//
//  EditGoalViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/21/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class EditGoalViewController: UIViewController {

	var viewModel: EditGoalViewModel!

	private let nameLabel = Label(style: .body)
	private let nameTextField = UITextField()
	private let timesPerWeekLabel = Label(style: .body)
	fileprivate let timesPerWeekStepper = Stepper()
	fileprivate let saveButton = UIButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
		navigationItem.leftBarButtonItem = cancelButtonItem
		self.view.backgroundColor = .white
		self.title = "Edit Goal"

		setupNameLabel()
		setupNameTextField()
		setupTimesPerWeekLabel()
		setupTimesPerWeekStepper()
		setupSaveButton()
	}

	// MARK: - Setup
	private func setupNameLabel() {
		nameLabel.text = "Enter a name for your goal"
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameLabel.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		nameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100).isActive = true
	}

	private func setupNameTextField() {
		nameTextField.delegate = self
		nameTextField.borderStyle = .line
		nameTextField.autocorrectionType = .no
		nameTextField.returnKeyType = .done
		view.addSubview(nameTextField)

		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
	}

	private func setupTimesPerWeekLabel() {
		view.addSubview(timesPerWeekLabel)

		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30).isActive = true
	}

	private func setupTimesPerWeekStepper() {
		timesPerWeekStepper.delegate = self
		view.addSubview(timesPerWeekStepper)
		viewModel.mutableGoal.frequency = timesPerWeekStepper.counter

		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekStepper.heightAnchor.constraint(equalToConstant: 100).isActive = true
		timesPerWeekStepper.widthAnchor.constraint(equalToConstant: 120).isActive = true
		timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: 15).isActive = true
	}

	private func setupSaveButton() {
		saveButton.setTitle("Save", for: .normal)
		saveButton.backgroundColor = .purple
		saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
		view.addSubview(saveButton)

		saveButton.translatesAutoresizingMaskIntoConstraints = false
		saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
		saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
		saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
	}

}

// MARK: - Navigation
extension EditGoalViewController {

	func save(_ saveButton: UIButton) {
		viewModel.updateGoal()
		_ = navigationController?.popToRootViewController(animated: true)
	}

	func cancel(_ cancelButton: UIButton) {
		_ = navigationController?.popToRootViewController(animated: true)
	}

	fileprivate func disableSaveButton() {
		saveButton.alpha = 0.5
		saveButton.isEnabled = false
	}

	fileprivate func enableSaveButton() {
		saveButton.alpha = 1.0
		saveButton.isEnabled = true
	}

}

extension EditGoalViewController: UITextFieldDelegate {

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.text?.isBlank == false {
			viewModel.mutableGoal.name = textField.text
			enableSaveButton()
		} else {
			disableSaveButton()
		}
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.resignFirstResponder()
	}

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

}

extension EditGoalViewController: StepperDelegate {
	func valueChanged(_ value: Int) {
		viewModel.mutableGoal.frequency = value
	}
}
