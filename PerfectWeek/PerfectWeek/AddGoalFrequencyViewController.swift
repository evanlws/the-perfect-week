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
		frequencyPrompt.text = "How often do you want to complete this goal?"
		view.addSubview(frequencyPrompt)

		frequencyPrompt.translatesAutoresizingMaskIntoConstraints = false
		frequencyPrompt.heightAnchor.constraint(equalToConstant: 60).isActive = true
		frequencyPrompt.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40).isActive = true
		frequencyPrompt.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
		frequencyPrompt.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}

	private func setupTimesPerWeekLabel() {
		timesPerWeekLabel.text = "Times per week"
		view.addSubview(timesPerWeekLabel)

		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekLabel.topAnchor.constraint(equalTo: frequencyPrompt.bottomAnchor, constant: 30).isActive = true
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

	private func setupNextButton() {
		let nextButton = UIButton()
		nextButton.setTitle("Save", for: .normal)
		nextButton.backgroundColor = .purple
		nextButton.addTarget(self, action: #selector(save(_:)), for: .touchUpInside)
		view.addSubview(nextButton)

		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
		nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
		nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
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
