//
//  AddGoalTypeViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/13/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalTypeViewController: UIViewController {

	// TODO: This should be a delegate
	fileprivate var goalType: GoalType {
		didSet {
			if oldValue != goalType {
				viewModel.mutableGoal.frequencyType = goalType
				setupView(forType: goalType)
			}
		}
	}

	var viewModel: AddGoalTypeViewModel!

	private let goalTypeLabel = Label(style: .body)
	fileprivate let goalTypeTextField = UITextField()
	private let timesPerWeekLabel = Label(style: .body)
	private let timesPerWeekStepper = Stepper()
	private let dueDateLabel = Label(style: .body)
	fileprivate let dueDateTextField = UITextField()
	fileprivate let dueDatePicker = UIDatePicker()
	private let onTheseDaysLabel = Label(style: .body)
	private let sunday = UIButton()
	private let monday = UIButton()
	private let tuesday = UIButton()
	private let wednesday = UIButton()
	private let thursday = UIButton()
	private let friday = UIButton()
	private let saturday = UIButton()

	init() {
		self.goalType = .weekly
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.title = "Add A Goal"

		setupGoalTypeLabel()
		setupGoalTextField()
		setupTimesPerWeekLabel()
		setupTimesPerWeekView()
		setupNextButton()
		setupDueDateLabel()
		setupGoalTextField()

		setupView(forType: goalType)
	}

	// MARK: - Setup
	private func setupView(forType: GoalType) {
		removeViews()

		switch goalType {
		case .weekly:
			viewModel.mutableGoal.frequencyType = .weekly
			timesPerWeekLabel.text = "Times per week:"
			setupTimesPerWeekLabel()
			setupTimesPerWeekView()
		case .daily:
			viewModel.mutableGoal.frequencyType = .daily
			timesPerWeekLabel.text = "Times per day:"
			setupTimesPerWeekLabel()
			setupTimesPerWeekView()
			setupOnTheseDaysLabel()
			setupWeekDays()
		case .once:
			viewModel.mutableGoal.frequencyType = .once
			setupDueDateLabel()
			setupDueDateTextField()
		}
	}

	private func removeViews() {
		onTheseDaysLabel.removeFromSuperview()
		timesPerWeekLabel.removeFromSuperview()
		timesPerWeekStepper.removeFromSuperview()
		sunday.removeFromSuperview()
		monday.removeFromSuperview()
		tuesday.removeFromSuperview()
		wednesday.removeFromSuperview()
		thursday.removeFromSuperview()
		friday.removeFromSuperview()
		saturday.removeFromSuperview()
		dueDateLabel.removeFromSuperview()
		dueDateTextField.removeFromSuperview()
	}

	private func setupGoalTypeLabel() {
		goalTypeLabel.text = "Goal Type:"
		view.addSubview(goalTypeLabel)

		goalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		goalTypeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
		goalTypeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		goalTypeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		goalTypeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100).isActive = true
	}

	private func setupGoalTextField() {
		goalTypeTextField.borderStyle = .line
		goalTypeTextField.text = "Weekly"
		view.addSubview(goalTypeTextField)

		let toolbar = UIToolbar()
		toolbar.barStyle = .default
		toolbar.isTranslucent = true
		toolbar.tintColor = .purple
		toolbar.isUserInteractionEnabled = true
		toolbar.sizeToFit()

		let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
		toolbar.setItems([spaceBarButtonItem, doneBarButtonItem], animated: false)
		goalTypeTextField.inputAccessoryView = toolbar

		let goalTypePickerView = UIPickerView()
		goalTypePickerView.delegate = self
		goalTypePickerView.dataSource = self
		goalTypeTextField.inputView = goalTypePickerView

		goalTypeTextField.translatesAutoresizingMaskIntoConstraints = false
		goalTypeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
		goalTypeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		goalTypeTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		goalTypeTextField.topAnchor.constraint(equalTo: goalTypeLabel.bottomAnchor, constant: 15).isActive = true
	}

	private func setupTimesPerWeekLabel() {
		timesPerWeekLabel.text = "Times per week:"
		view.addSubview(timesPerWeekLabel)

		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekLabel.topAnchor.constraint(equalTo: goalTypeTextField.bottomAnchor, constant: 30).isActive = true
	}

	private func setupTimesPerWeekView() {
		timesPerWeekStepper.delegate = self
		view.addSubview(timesPerWeekStepper)

		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekStepper.heightAnchor.constraint(equalToConstant: 100).isActive = true
		timesPerWeekStepper.widthAnchor.constraint(equalToConstant: 120).isActive = true
		timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: 15).isActive = true
	}

	private func setupOnTheseDaysLabel() {
		onTheseDaysLabel.text = "On these days:"
		view.addSubview(onTheseDaysLabel)

		onTheseDaysLabel.translatesAutoresizingMaskIntoConstraints = false
		onTheseDaysLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
		onTheseDaysLabel.topAnchor.constraint(equalTo: timesPerWeekStepper.bottomAnchor, constant: 30).isActive = true
		onTheseDaysLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
		onTheseDaysLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}

	private func setupWeekDays() {
		sunday.setTitle("Su", for: .normal)
		monday.setTitle("M", for: .normal)
		tuesday.setTitle("Tu", for: .normal)
		wednesday.setTitle("W", for: .normal)
		thursday.setTitle("Th", for: .normal)
		friday.setTitle("F", for: .normal)
		saturday.setTitle("Sa", for: .normal)

		for button in [sunday, monday, tuesday, wednesday, thursday, friday, saturday] {
			button.backgroundColor = .purple
			button.tag = 2
			button.addTarget(self, action: #selector(toggleWeekday(_:)), for: .touchUpInside)
			view.addSubview(button)
			button.translatesAutoresizingMaskIntoConstraints = false
			button.widthAnchor.constraint(equalToConstant: 35).isActive = true
			button.heightAnchor.constraint(equalToConstant: 35).isActive = true
			button.topAnchor.constraint(equalTo: onTheseDaysLabel.bottomAnchor, constant: 10).isActive = true
		}

		wednesday.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		tuesday.rightAnchor.constraint(equalTo: wednesday.leftAnchor, constant: -5).isActive = true
		monday.rightAnchor.constraint(equalTo: tuesday.leftAnchor, constant: -5).isActive = true
		sunday.rightAnchor.constraint(equalTo: monday.leftAnchor, constant: -5).isActive = true
		thursday.leftAnchor.constraint(equalTo: wednesday.rightAnchor, constant: 5).isActive = true
		friday.leftAnchor.constraint(equalTo: thursday.rightAnchor, constant: 5).isActive = true
		saturday.leftAnchor.constraint(equalTo: friday.rightAnchor, constant: 5).isActive = true
	}

	private func setupDueDateLabel() {
		dueDateLabel.text = "Due Date:"
		view.addSubview(dueDateLabel)

		dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
		dueDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		dueDateLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		dueDateLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		dueDateLabel.topAnchor.constraint(equalTo: goalTypeTextField.bottomAnchor, constant: 30).isActive = true
	}

	private func setupDueDateTextField() {
		dueDateTextField.borderStyle = .line
		dueDateTextField.text = ""
		view.addSubview(dueDateTextField)

		let toolbar = UIToolbar()
		toolbar.barStyle = .default
		toolbar.isTranslucent = true
		toolbar.tintColor = .purple
		toolbar.isUserInteractionEnabled = true
		toolbar.sizeToFit()

		let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		let doneBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissPickerView))
		toolbar.setItems([spaceBarButtonItem, doneBarButtonItem], animated: false)
		dueDateTextField.inputAccessoryView = toolbar
		dueDatePicker.datePickerMode = .date
		dueDatePicker.minimumDate = Date()
		dueDateTextField.inputView = dueDatePicker

		dueDateTextField.translatesAutoresizingMaskIntoConstraints = false
		dueDateTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
		dueDateTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		dueDateTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		dueDateTextField.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 15).isActive = true
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

	// MARK: - Helper functions
	func toggleWeekday(_ sender: UIButton) {
		if sender.tag == 1 {
			sender.tag = 2
			sender.backgroundColor = .purple
		} else {
			sender.tag = 1
			sender.backgroundColor = .gray
		}

		viewModel.mutableGoal.days = filteredWeekdays()
	}

	private func filteredWeekdays() -> [Int] {
		let weekdays = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
		return weekdays.filter { $0.tag == 2 }.map { weekdays.index(of: $0)! }
	}
}

// MARK: - Navigation
extension AddGoalTypeViewController {

	func save(_ saveButton: UIButton) {
		viewModel.setMutableGoalItems()
		viewModel.addGoal()
		dismiss(animated: true, completion: nil)
	}

}

extension AddGoalTypeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 3
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch row {
		case 0:
			return "Weekly"
		case 1:
			return "Daily"
		default:
			return "Once"
		}
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		switch row {
		case 0:
			goalType = .weekly
			goalTypeTextField.text = "Weekly"
		case 1:
			goalType = .daily
			goalTypeTextField.text = "Daily"
		default:
			goalType = .once
			goalTypeTextField.text = "Once"
		}
	}

	func dismissPickerView() {
		view.endEditing(true)

		if let month = Calendar.current.dateComponents([.month], from: dueDatePicker.date).month,
			let day = Calendar.current.dateComponents([.day], from: dueDatePicker.date).day,
			let year = Calendar.current.dateComponents([.year], from: dueDatePicker.date).year,
			goalType == .once {
			dueDateTextField.text = "\(month)/\(day)/\(year)"
		}
	}

}

extension AddGoalTypeViewController: StepperDelegate {
	func valueChanged(_ value: Int) {
		guard let frequency = viewModel.mutableGoal.frequencyType else { return }

		switch frequency {
		case .weekly:
			viewModel.mutableGoal.timesPerWeek = value
		case .daily:
			viewModel.mutableGoal.timesPerDay = value
		default:
			return
		}
	}
}
