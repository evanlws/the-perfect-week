//
//  AddGoalTypeViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/13/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class AddGoalTypeViewController: UIViewController {

	var viewModel: AddGoalTypeViewModel
	let goalTypeLabel = UILabel()
	let goalTypeTextField = UITextField()
	let timesPerWeekLabel = UILabel()
	let timesPerWeekStepper = Stepper()

	init(_ dataSource: AddGoalDataSource) {
		self.viewModel = AddGoalTypeViewModel(dataSource)
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
	}

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
		nextButton.topAnchor.constraint(equalTo: timesPerWeekStepper.bottomAnchor, constant: 30).isActive = true
		nextButton.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -50).isActive = true
	}

	// MARK: - Navigation
	func next(_ sender: UIButton) {
		viewModel.dataSource.setGoalTimesPerWeek(timesPerWeek: timesPerWeekStepper.counter)
		viewModel.dataSource.saveGoal()
		dismiss(animated: true, completion: nil)
	}

}

extension AddGoalTypeViewController: UIPickerViewDelegate, UIPickerViewDataSource {

	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 1
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return "Weekly"
	}

	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		goalTypeTextField.text = "Weekly"
	}

	func dismissPickerView() {
		view.endEditing(true)
	}

}
