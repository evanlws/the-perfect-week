//
//  AddGoalTypeViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/13/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class AddGoalTypeViewController: UIViewController {

	fileprivate var goalType: GoalType {
		didSet {
			goalTypeDidChange()
		}
	}

	fileprivate var viewModel: AddGoalTypeViewModel
	fileprivate let goalTypeLabel = UILabel()
	fileprivate let goalTypeTextField = UITextField()
	fileprivate let timesPerWeekLabel = UILabel()
	fileprivate let timesPerWeekStepper = Stepper()
	fileprivate let onTheseDaysLabel = UILabel()
	fileprivate let sunday = UIButton()
	fileprivate let monday = UIButton()
	fileprivate let tuesday = UIButton()
	fileprivate let wednesday = UIButton()
	fileprivate let thursday = UIButton()
	fileprivate let friday = UIButton()
	fileprivate let saturday = UIButton()
	fileprivate let dueDateLabel = UILabel()
	fileprivate let dueDateTextField = UITextField()
	fileprivate let dueDatePicker = UIDatePicker()

	init(_ dataSource: AddGoalDataSource) {
		self.viewModel = AddGoalTypeViewModel(dataSource)
		self.goalType = .weekly
		super.init(nibName: nil, bundle: nil)
		self.view.backgroundColor = .white
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Add A Goal"
		setupGoalTypeLabel()
		setupGoalTextField()
		setupTimesPerWeekLabel()
		setupTimesPerWeekView()
		setupNextButton()
		setupDueDateLabel()
		setupGoalTextField()
		goalTypeDidChange()
	}

	// MARK: - Setup
	fileprivate func setupGoalTypeLabel() {
		goalTypeLabel.text = "Goal Type:"
		goalTypeLabel.font = UIFont.systemFont(ofSize: 18)
		goalTypeLabel.minimumScaleFactor = 0.6
		goalTypeLabel.textColor = .black
		goalTypeLabel.textAlignment = .left
		view.addSubview(goalTypeLabel)

		goalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
		goalTypeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
		goalTypeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -10).isActive = true
		goalTypeLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		goalTypeLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100).isActive = true
	}

	fileprivate func setupGoalTextField() {
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

	fileprivate func setupTimesPerWeekLabel() {
		timesPerWeekLabel.text = "Times per week:"
		timesPerWeekLabel.font = UIFont.systemFont(ofSize: 18)
		timesPerWeekLabel.minimumScaleFactor = 0.6
		timesPerWeekLabel.textColor = .black
		timesPerWeekLabel.textAlignment = .left
		view.addSubview(timesPerWeekLabel)

		timesPerWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		timesPerWeekLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		timesPerWeekLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekLabel.topAnchor.constraint(equalTo: goalTypeTextField.bottomAnchor, constant: 30).isActive = true
	}

	fileprivate func setupTimesPerWeekView() {
		view.addSubview(timesPerWeekStepper)

		timesPerWeekStepper.translatesAutoresizingMaskIntoConstraints = false
		timesPerWeekStepper.heightAnchor.constraint(equalToConstant: 100).isActive = true
		timesPerWeekStepper.widthAnchor.constraint(equalToConstant: 120).isActive = true
		timesPerWeekStepper.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		timesPerWeekStepper.topAnchor.constraint(equalTo: timesPerWeekLabel.bottomAnchor, constant: 15).isActive = true
	}

	fileprivate func setupOnTheseDaysLabel() {
		onTheseDaysLabel.text = "On these days:"
		onTheseDaysLabel.font = UIFont.systemFont(ofSize: 18)
		onTheseDaysLabel.minimumScaleFactor = 0.6
		onTheseDaysLabel.textColor = .black
		onTheseDaysLabel.textAlignment = .left
		view.addSubview(onTheseDaysLabel)

		onTheseDaysLabel.translatesAutoresizingMaskIntoConstraints = false
		onTheseDaysLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
		onTheseDaysLabel.topAnchor.constraint(equalTo: timesPerWeekStepper.bottomAnchor, constant: 30).isActive = true
		onTheseDaysLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
		onTheseDaysLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
	}

	fileprivate func setupWeekDays() {
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

	fileprivate func setupDueDateLabel() {
		dueDateLabel.text = "Due Date:"
		dueDateLabel.font = UIFont.systemFont(ofSize: 18)
		dueDateLabel.minimumScaleFactor = 0.6
		dueDateLabel.textColor = .black
		dueDateLabel.textAlignment = .left
		view.addSubview(dueDateLabel)

		dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
		dueDateLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
		dueDateLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20).isActive = true
		dueDateLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
		dueDateLabel.topAnchor.constraint(equalTo: goalTypeTextField.bottomAnchor, constant: 30).isActive = true
	}

	fileprivate func setupDueDateTextField() {
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

	fileprivate func setupNextButton() {
		let nextButton = UIButton()
		nextButton.setTitle("Save", for: .normal)
		nextButton.backgroundColor = .purple
		nextButton.addTarget(self, action: #selector(next(_:)), for: .touchUpInside)
		view.addSubview(nextButton)

		nextButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
		nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
		nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
	}

	fileprivate func goalTypeDidChange() {
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

		switch goalType {
		case .weekly:
			timesPerWeekLabel.text = "Times per week:"
			setupTimesPerWeekLabel()
			setupTimesPerWeekView()
		case .daily:
			timesPerWeekLabel.text = "Times per day:"
			setupTimesPerWeekLabel()
			setupTimesPerWeekView()
			setupOnTheseDaysLabel()
			setupWeekDays()
		case .once:
			setupDueDateLabel()
			setupDueDateTextField()
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

	fileprivate func filteredWeekdays() -> [Int] {
		let weekdays = [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
		return weekdays.filter { $0.tag == 2 }.map { weekdays.index(of: $0)! }
	}

	// MARK: - Navigation
	func next(_ sender: UIButton) {
		if viewModel.dataSource.isValid(
			goalType,
			timesPerNumber:
			timesPerWeekStepper.counter,
			onTheseDays: filteredWeekdays(),
			dueDate: dueDatePicker.date) {
			viewModel.dataSource.saveGoal()
			dismiss(animated: true, completion: nil)
		}
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
