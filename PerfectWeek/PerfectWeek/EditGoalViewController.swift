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
		navigationController?.setNavigationBarHidden(false, animated: true)
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

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		InformationHeaderObserver.shouldHideInformationHeader()
	}

	// MARK: - Setup
	private func setupNameLabel() {
		nameLabel.text = "Name"
		view.addSubview(nameLabel)

		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			nameLabel.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),
			nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			nameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100)
		])
	}

	private func setupNameTextField() {
		nameTextField.delegate = self
		nameTextField.borderStyle = .line
		nameTextField.autocorrectionType = .no
		nameTextField.returnKeyType = .done
		view.addSubview(nameTextField)

		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			nameTextField.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			nameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
		])
	}

	private func setupTimesPerWeekLabel() {
		timesPerWeekLabel.text = "Times per week"
		view.addSubview(timesPerWeekLabel)

		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			timesPerWeekLabel.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
			timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30)
		])
	}

	private func setupTimesPerWeekStepper() {
		timesPerWeekStepper.delegate = self
		view.addSubview(timesPerWeekStepper)
		viewModel.mutableGoal.frequency = timesPerWeekStepper.counter

		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			timesPerWeekStepper.heightAnchor.constraint(equalToConstant: 100),
			timesPerWeekStepper.widthAnchor.constraint(equalToConstant: 120),
			timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: 15)
		])
	}

	private func setupSaveButton() {
		saveButton.setTitle("Save", for: .normal)
		saveButton.backgroundColor = .purple
		saveButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
		view.addSubview(saveButton)

		saveButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			saveButton.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
		])
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
