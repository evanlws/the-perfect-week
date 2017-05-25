//
//  AddGoalNameViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/5/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalNameViewController: UIViewController {

	var viewModel: AddGoalNameViewModel

	fileprivate let nameLabel: Label = {
		let label = Label(style: .body)
		label.text = LocalizedStrings.enterGoalName
		label.textAlignment = .center
		return label
	}()

	private let nameTextField: UITextField = {
		let textField = UITextField()
		textField.borderStyle = .none
		textField.autocorrectionType = .no
		textField.returnKeyType = .done
		textField.textAlignment = .center
		textField.contentVerticalAlignment = .bottom
		return textField
	}()

	private let nextButton: UIButton = {
		let button = Button.initialize(type: .basicBox)
		button.setTitle(LocalizedStrings.next, for: .normal)
		button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
		return button
	}()

	var path: UIBezierPath?

	init(viewModel: AddGoalNameViewModel) {
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
		navigationController?.setNavigationBarHidden(false, animated: true)
		InformationHeaderObserver.shouldHideInformationHeader()
		navigationController?.navigationBar.tintColor = .black
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if path == nil {
			path = UIBezierPath()
			path?.move(to: CGPoint(x: 0, y: nameTextField.frame.size.height))
			path?.addLine(to: CGPoint(x: nameTextField.frame.size.width, y: nameTextField.frame.size.height))
			let underline = CAShapeLayer()
			underline.path = path?.cgPath
			underline.lineWidth = 2.0
			underline.strokeColor = UIColor.black.cgColor
			nameTextField.layer.addSublayer(underline)
		}
	}

	private func configureViews() {
		let cancelButtonItem = UIBarButtonItem(title: LocalizedStrings.cancel, style: .plain, target: self, action: #selector(didTapCancelBarButtonItem))
		navigationItem.rightBarButtonItem = cancelButtonItem
		view.backgroundColor = .white
		title = LocalizedStrings.addGoal

		nameTextField.delegate = self
		view.addSubview(nameLabel)
		view.addSubview(nameTextField)
		view.addSubview(nextButton)

		disableNextButton()
	}

	private func configureConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		nextButton.translatesAutoresizingMaskIntoConstraints = false

		let height: CGFloat = 30
		NSLayoutConstraint.activate([
			nameLabel.heightAnchor.constraint(equalToConstant: height),
			nameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10),
			nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant:-height),
			nameTextField.heightAnchor.constraint(equalToConstant: height),
			nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64),
			nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nameTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: height),
			nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
			nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -112),
			nextButton.heightAnchor.constraint(equalToConstant: 30)
		])

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

// MARK: - Actions
extension AddGoalNameViewController {

	func didTapNextButton() {
		presentAddGoalFrequencyVC()
	}

	func didTapCancelBarButtonItem() {
		dismissCurrentVC()
	}

}

// MARK: - Navigation
extension AddGoalNameViewController {

	fileprivate func presentAddGoalFrequencyVC() {
		let addGoalFrequencyVC = AddGoalFrequencyViewController(viewModel: AddGoalFrequencyViewModel(mutableGoal: viewModel.mutableGoal))
		navigationController?.pushViewController(addGoalFrequencyVC, animated: true)
	}

	fileprivate func dismissCurrentVC() {
		dismiss(animated: true, completion: nil)
	}

}

extension AddGoalNameViewController: UITextFieldDelegate {

	func textFieldDidEndEditing(_ textField: UITextField) {
		if textField.text?.isBlank == false {
			viewModel.mutableGoal.name = textField.text
			enableNextButton()
		}
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

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		return textField.resignFirstResponder()
	}

}
