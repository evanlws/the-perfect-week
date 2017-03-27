//
//  EditGoalViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/21/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class EditGoalViewController: UIViewController {

	// TODO: This should be a delegate
	fileprivate var goalType: GoalType {
		didSet {
			if oldValue != goalType {
				viewModel.mutableGoal.frequencyType = goalType
				setupView(forType: goalType)
			}
		}
	}

	var viewModel: EditGoalViewModel!

	private let nameLabel = Label(style: .body)
	private let nameTextField = UITextField()
	private let goalTypeLabel = Label(style: .body)
	fileprivate let goalTypeTextField = UITextField()
	private let timesPerWeekLabel = Label(style: .body)
	fileprivate let timesPerWeekStepper = Stepper()
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
		self.title = "Edit Goal"

		setupNameLabel()
		setupNameTextField()
		setupGoalTypeLabel()
		setupGoalTextField()
		setupTimesPerWeekLabel()
		setupTimesPerWeekView()
		setupSaveButton()
		setupDueDateLabel()
		setupGoalTextField()

		setupView(forType: goalType)

		populateGoalData()
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
		view.addSubview(nameTextField)

		nameTextField.translatesAutoresizingMaskIntoConstraints = false
		let height: CGFloat = 30
		nameTextField.heightAnchor.constraint(equalToConstant: height).isActive = true
		nameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		nameTextField.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
	}

	private func setupGoalTypeLabel() {
		goalTypeLabel.text = "Goal Type:"
		view.addSubview(goalTypeLabel)

		goalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		goalTypeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
		goalTypeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		goalTypeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		goalTypeLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15).isActive = true
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

	private func setupSaveButton() {
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

	private func populateGoalData() {
		let goal = viewModel.mutableGoal

		nameTextField.text = goal.name
		goalTypeTextField.text = goal.frequency?.type.description

		if let weekly = goal.frequency as? Weekly {
			timesPerWeekStepper.counter = weekly.timesPerWeek
		} else if let daily = goal.frequency as? Daily {
			timesPerWeekStepper.counter = daily.timesPerDay

			sunday.tag = daily.days.contains(0) ? 2 : 1
			monday.tag = daily.days.contains(1) ? 2 : 1
			tuesday.tag = daily.days.contains(2) ? 2 : 1
			wednesday.tag = daily.days.contains(3) ? 2 : 1
			thursday.tag = daily.days.contains(4) ? 2 : 1
			friday.tag = daily.days.contains(5) ? 2 : 1
			saturday.tag = daily.days.contains(6) ? 2 : 1
		} else if let once = goal.frequency as? Once {
			if let month = Calendar.current.dateComponents([.month], from: once.dueDate).month,
				let day = Calendar.current.dateComponents([.day], from: once.dueDate).day,
				let year = Calendar.current.dateComponents([.year], from: once.dueDate).year,
				goalType == .once {
				dueDateTextField.text = "\(month)/\(day)/\(year)"
			}
		}

	}

	func toggleWeekday(_ sender: UIButton) {
		if sender.tag == 1 {
			sender.tag = 2
			sender.backgroundColor = .purple
		} else {
			sender.tag = 1
			sender.backgroundColor = .gray
		}
	}

	private func filteredWeekdays() -> [Int] {
		let weekdays = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
		return weekdays.filter { $0.tag == 2 }.map { weekdays.index(of: $0)! }
	}

}

// MARK: - Navigation
extension EditGoalViewController {

	func save(_ sender: UIButton) {
		if let frequency = viewModel.mutableGoal.frequencyType {
			switch frequency {
			case .weekly:
				viewModel.mutableGoal.timesPerWeek = timesPerWeekStepper.counter
			case .daily:
				viewModel.mutableGoal.timesPerDay = timesPerWeekStepper.counter
			case .once:
				break
			}
		}

		viewModel.updateGoal()
		_ = navigationController?.popToRootViewController(animated: true)
	}

}

extension EditGoalViewController: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if let text = textField.text {
			viewModel.mutableGoal.name = text
		}

		return textField.resignFirstResponder()
	}

}

extension EditGoalViewController: UIPickerViewDelegate, UIPickerViewDataSource {

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
