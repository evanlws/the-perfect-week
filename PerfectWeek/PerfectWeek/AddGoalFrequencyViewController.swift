//
//  AddGoalFrequencyViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/13/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalFrequencyViewController: UIViewController {

	var viewModel: AddGoalFrequencyViewModel

	private let frequencyPrompt: Label = {
		let label = Label(style: .header)
		label.text = LocalizedStrings.goalCompletionFrequencyPrompt
		label.numberOfLines = 0
		return label
	}()

	private let timesPerWeekLabel: Label = {
		let label = Label(style: .body)
		label.text = LocalizedStrings.timesPerWeek
		return label
	}()

	private let timesPerWeekStepper = Stepper()

	private let notesTextLabel: Label = {
		let label = Label(style: .body)
		label.text = LocalizedStrings.addNotesPrompt
		label.numberOfLines = 0
		return label
	}()

	fileprivate let notesTextView = UITextView()

	private let notesTextViewButton = UIButton()

	private let nextButton: UIButton = {
		let button = UIButton()
		button.setTitle(LocalizedStrings.save, for: .normal)
		button.backgroundColor = .purple
		return button
	}()

	init(viewModel: AddGoalFrequencyViewModel) {
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
		NotificationManager.requestNotificationsPermission()
		navigationController?.setNavigationBarHidden(true, animated: true)
		InformationHeaderObserver.shouldHideInformationHeader()
	}

	// MARK: - Setup
	private func configureViews() {
		let cancelButtonItem = UIBarButtonItem(title: LocalizedStrings.cancel, style: .plain, target: self, action: #selector(cancel))
		navigationItem.leftBarButtonItem = cancelButtonItem
		self.view.backgroundColor = .white
		self.title = LocalizedStrings.addGoal
		timesPerWeekStepper.delegate = self
		viewModel.mutableGoal.frequency = timesPerWeekStepper.counter
		nextButton.addTarget(self, action: #selector(save), for: .touchUpInside)
		notesTextView.backgroundColor = .gray
		notesTextViewButton.setTitle("", for: .normal)
		notesTextViewButton.addTarget(self, action: #selector(didTapNotesTextViewButton), for: .touchUpInside)

		view.addSubview(frequencyPrompt)
		view.addSubview(timesPerWeekLabel)
		view.addSubview(timesPerWeekStepper)
		view.addSubview(notesTextLabel)
		view.addSubview(notesTextView)
		view.addSubview(notesTextViewButton)
		view.addSubview(nextButton)
	}

	private func configureConstraints() {
		frequencyPrompt.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		notesTextLabel.translatesAutoresizingMaskIntoConstraints = false
		notesTextView.translatesAutoresizingMaskIntoConstraints = false
		notesTextViewButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.translatesAutoresizingMaskIntoConstraints = false

		let navigationBarHeight = navigationController?.navigationBar.bounds.size.height ?? 0
		NSLayoutConstraint.activate([
			frequencyPrompt.heightAnchor.constraint(equalToConstant: 60),
			frequencyPrompt.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
			frequencyPrompt.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: navigationBarHeight + 40),
			frequencyPrompt.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			timesPerWeekLabel.heightAnchor.constraint(equalToConstant: 30),
			timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			timesPerWeekLabel.topAnchor.constraint(equalTo: frequencyPrompt.bottomAnchor, constant: 30),
			timesPerWeekStepper.heightAnchor.constraint(equalToConstant: 100),
			timesPerWeekStepper.widthAnchor.constraint(equalToConstant: 120),
			timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: 15),
			notesTextLabel.topAnchor.constraint(equalTo: timesPerWeekStepper.bottomAnchor, constant: 30),
			notesTextLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			notesTextLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			notesTextView.topAnchor.constraint(equalTo: notesTextLabel.bottomAnchor, constant: 15),
			notesTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			notesTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			notesTextView.heightAnchor.constraint(equalToConstant: 150),
			notesTextViewButton.topAnchor.constraint(equalTo: notesTextLabel.bottomAnchor, constant: 15),
			notesTextViewButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			notesTextViewButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			notesTextViewButton.heightAnchor.constraint(equalToConstant: 150),
			nextButton.heightAnchor.constraint(equalToConstant: 30),
			nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
			nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
		])
	}

}

// MARK: - Actions
extension AddGoalFrequencyViewController {

	func didTapNotesTextViewButton() {
		let alertController = UIAlertController(title: LocalizedStrings.addNotesPrompt, message: nil, preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: LocalizedStrings.cancel, style: .cancel) { _ in
			alertController.dismiss(animated: true, completion: nil)
		}

		let saveAction = UIAlertAction(title: LocalizedStrings.save, style: .default) { [weak self] _ in
			if let textField = alertController.textFields?.first {
				self?.viewModel.mutableGoal.notes = textField.text
				self?.notesTextView.text = textField.text
			}

			alertController.dismiss(animated: true, completion: nil)
		}

		alertController.addAction(cancelAction)
		alertController.addAction(saveAction)

		alertController.addTextField(configurationHandler: nil)

		self.present(alertController, animated: true, completion: nil)
	}

}

// MARK: - Navigation
extension AddGoalFrequencyViewController {

	func save() {
		viewModel.addGoal()
		dismiss(animated: true, completion: nil)
	}

	func cancel() {
		dismiss(animated: true, completion: nil)
	}

}

extension AddGoalFrequencyViewController: StepperDelegate {

	func valueChanged(_ value: Int) {
		viewModel.mutableGoal.frequency = value
	}

}
