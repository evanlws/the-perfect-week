//
//  EditGoalViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/21/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class EditGoalViewController: UIViewController {

	var viewModel: EditGoalViewModel

	private let nameLabel: Label = {
		let label = Label(style: .body)
		label.text = LocalizedStrings.name
		return label
	}()

	private let nameTextField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .line
		textField.autocorrectionType = .no
		textField.returnKeyType = .done
		return textField
	}()

	private let timesPerWeekLabel: Label = {
		let label = Label(style: .body)
		label.text = LocalizedStrings.timesPerWeek
		return label
	}()

	private let timesPerWeekStepper = Stepper()

	fileprivate let saveButton: UIButton = {
		let button = UIButton()
		button.setTitle(LocalizedStrings.save, for: .normal)
		button.backgroundColor = .purple
		button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
		return button
	}()

	init(viewModel: EditGoalViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureViews()
		configureConstraints()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		InformationHeaderObserver.shouldHideInformationHeader()
	}

	// MARK: - Setup
	private func configureViews() {
		let cancelButtonItem = UIBarButtonItem(title: LocalizedStrings.cancel, style: .plain, target: self, action: #selector(didTapCancelBarButtonItem))
		navigationItem.leftBarButtonItem = cancelButtonItem
		navigationController?.setNavigationBarHidden(false, animated: true)
		view.backgroundColor = .white
		title = LocalizedStrings.editGoal
		nameTextField.delegate = self
		timesPerWeekStepper.delegate = self
		viewModel.mutableGoal.frequency = timesPerWeekStepper.counter

		view.addSubview(nameLabel)
		view.addSubview(nameTextField)
		view.addSubview(timesPerWeekLabel)
		view.addSubview(timesPerWeekStepper)
		view.addSubview(saveButton)
	}

	private func configureConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		saveButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			nameLabel.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),
			nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			nameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
			nameTextField.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			nameTextField.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
			timesPerWeekLabel.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
			timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
			timesPerWeekStepper.heightAnchor.constraint(equalToConstant: 100),
			timesPerWeekStepper.widthAnchor.constraint(equalToConstant: 120),
			timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: 15),
			saveButton.heightAnchor.constraint(equalToConstant: Label.defaultHeight),
			saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
			saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
		])
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

// MARK: - Actions
extension EditGoalViewController {

	func didTapSaveButton() {
		updateGoal()
		presentGoalsVC()
	}

	func didTapCancelBarButtonItem() {
		presentGoalsVC()
	}

}

// MARK: - Navigation
extension EditGoalViewController {

	func updateGoal() {
		viewModel.updateGoal()
	}

	func presentGoalsVC() {
		_ = navigationController?.popToRootViewController(animated: true)
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
