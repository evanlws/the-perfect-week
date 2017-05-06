//
//  AddGoalFrequencyViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/13/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalFrequencyViewController: UIViewController {

	var viewModel: AddGoalFrequencyViewModel!

	private let frequencyPrompt = Label(style: .body)
	private let timesPerWeekLabel = Label(style: .body)
	private let timesPerWeekStepper = Stepper()

	override func viewDidLoad() {
		super.viewDidLoad()
		let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
		navigationItem.leftBarButtonItem = cancelButtonItem
		self.view.backgroundColor = .white
		self.title = "Add Goal"

		setupFrequencyPrompt()
		setupTimesPerWeekLabel()
		setupTimesPerWeekStepper()
		setupNextButton()
	}

	// MARK: - Setup
	private func setupFrequencyPrompt() {
		view.addSubview(frequencyPrompt)

		frequencyPrompt.translatesAutoresizingMaskIntoConstraints = false
		let navigationBarHeight = navigationController?.navigationBar.bounds.size.height ?? 0
		NSLayoutConstraint.activate([
			frequencyPrompt.heightAnchor.constraint(equalToConstant: 60),
			frequencyPrompt.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
			frequencyPrompt.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: navigationBarHeight + 40),
			frequencyPrompt.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		])

	}

	private func setupTimesPerWeekLabel() {
		view.addSubview(timesPerWeekLabel)

		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			timesPerWeekLabel.heightAnchor.constraint(equalToConstant: 30),
			timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20),
			timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			timesPerWeekLabel.topAnchor.constraint(equalTo: frequencyPrompt.bottomAnchor, constant: 30)
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

	private func setupNextButton() {
		let nextButton = UIButton()
		nextButton.setTitle("Save", for: .normal)
		nextButton.backgroundColor = .purple
		nextButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
		view.addSubview(nextButton)

		nextButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			nextButton.heightAnchor.constraint(equalToConstant: 30),
			nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
			nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
		])
	}

}

// MARK: - Navigation
extension AddGoalFrequencyViewController {

	func save(_ saveButton: UIButton) {
		viewModel.addGoal()
		dismiss(animated: true, completion: nil)
	}

	func cancel(_ cancelBarButtonItem: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

}

extension AddGoalFrequencyViewController: StepperDelegate {

	func valueChanged(_ value: Int) {
		viewModel.mutableGoal.frequency = value
	}

}
