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
		let label = Label(style: .body1, alignment: .center)
		label.text = LocalizedStrings.goalCompletionFrequencyPrompt
		label.numberOfLines = 0
		return label
	}()

	private let timesPerWeekLabel: Label = {
		let label = Label(style: .body3)
		label.text = LocalizedStrings.timesPerWeek
		return label
	}()

	private let timesPerWeekStepper = Stepper()

	private let notesTextLabel: Label = {
		let label = Label(style: .body3)
		label.text = LocalizedStrings.addNotesPrompt
		label.numberOfLines = 0
		return label
	}()

	fileprivate let notesTextView = UITextView()

	private let notesTextViewButton = UIButton()

	private let addGoalButton: UIButton = {
		let button = Button.initialize(type: .basicBox)
		button.setTitle(LocalizedStrings.addGoal, for: .normal)
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
		navigationController?.setNavigationBarHidden(false, animated: true)
		navigationController?.navigationBar.tintColor = .black
		InformationHeaderObserver.shouldHideInformationHeader()
	}

	// MARK: - Setup
	private func configureViews() {
		let cancelButtonItem = UIBarButtonItem(title: LocalizedStrings.cancel, style: .plain, target: self, action: #selector(didTapCancelBarButtonItem))
		navigationItem.rightBarButtonItem = cancelButtonItem
		self.view.backgroundColor = .white
		self.title = LocalizedStrings.addGoal
		timesPerWeekStepper.delegate = self
		viewModel.mutableGoal.frequency = timesPerWeekStepper.counter
		addGoalButton.addTarget(self, action: #selector(didTapAddGoalButton), for: .touchUpInside)
		notesTextView.layer.borderColor = UIColor.black.cgColor
		notesTextView.layer.borderWidth = 1.0
		notesTextViewButton.setTitle("", for: .normal)
		notesTextViewButton.addTarget(self, action: #selector(didTapNotesTextViewButton), for: .touchUpInside)

		view.addSubview(frequencyPrompt)
		view.addSubview(timesPerWeekLabel)
		view.addSubview(timesPerWeekStepper)
		view.addSubview(notesTextLabel)
		view.addSubview(notesTextView)
		view.addSubview(notesTextViewButton)
		view.addSubview(addGoalButton)
	}

	private func configureConstraints() {
		frequencyPrompt.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		notesTextLabel.translatesAutoresizingMaskIntoConstraints = false
		notesTextView.translatesAutoresizingMaskIntoConstraints = false
		notesTextViewButton.translatesAutoresizingMaskIntoConstraints = false
		addGoalButton.translatesAutoresizingMaskIntoConstraints = false

		let navigationBarHeight = navigationController?.navigationBar.bounds.size.height ?? 0

		NSLayoutConstraint.activate([
			frequencyPrompt.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight + Constraints.gridBlock * 5),
			frequencyPrompt.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.gridBlock * 8),
			frequencyPrompt.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.gridBlock * 8),

			timesPerWeekLabel.topAnchor.constraint(equalTo: frequencyPrompt.bottomAnchor, constant: Constraints.gridBlock * 5),
			timesPerWeekLabel.heightAnchor.constraint(equalToConstant: Constraints.gridBlock * 3),
			timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.horizontalMargin),
			timesPerWeekLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.horizontalMargin),

			timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: Constraints.gridBlock * 2),
			timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.horizontalMargin),
			timesPerWeekStepper.widthAnchor.constraint(equalToConstant: Constraints.gridBlock * 16),
			timesPerWeekStepper.heightAnchor.constraint(equalToConstant: Constraints.gridBlock * 10),

			notesTextLabel.topAnchor.constraint(equalTo: timesPerWeekStepper.bottomAnchor, constant: Constraints.gridBlock * 4),
			notesTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.horizontalMargin),
			notesTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.horizontalMargin),

			notesTextView.topAnchor.constraint(equalTo: notesTextLabel.bottomAnchor, constant: Constraints.gridBlock * 2),
			notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.horizontalMargin),
			notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.horizontalMargin),
			notesTextView.heightAnchor.constraint(equalToConstant: Constraints.gridBlock * 10),

			notesTextViewButton.topAnchor.constraint(equalTo: notesTextLabel.bottomAnchor, constant: Constraints.gridBlock * 2),
			notesTextViewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.horizontalMargin),
			notesTextViewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.horizontalMargin),
			notesTextViewButton.heightAnchor.constraint(equalToConstant: Constraints.gridBlock * 10),

			addGoalButton.heightAnchor.constraint(equalToConstant: Constraints.gridBlock * 4),
			addGoalButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constraints.gridBlock * 7),
			addGoalButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constraints.gridBlock * 7),
			addGoalButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constraints.gridBlock * 11)
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

	func didTapAddGoalButton() {
		save()
	}

	func didTapCancelBarButtonItem() {
		cancel()
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
