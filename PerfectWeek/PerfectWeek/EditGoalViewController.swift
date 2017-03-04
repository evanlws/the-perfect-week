//
//  EditGoalViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/27/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit
import RealmSwift

class EditGoalViewController: UIViewController {

    init(goal: Goal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        goalTypeDidChange()
        view.backgroundColor = .white
    }

    let goal: Goal
    let goalNameLabel = UILabel()
    let goalNameTextField = UITextField()
    let goalTypeLabel = UILabel()
    let goalTypePickerView = UIPickerView()
    let goalTypeTextField = UITextField()
    let saveButton = UIButton()
    var timesPerLabel: UILabel?
    var timesPerTextField: UITextField?
    var onTheseDaysLabel: UILabel?
    var sunday: UIButton?
    var monday: UIButton?
    var tuesday: UIButton?
    var wednesday: UIButton?
    var thursday: UIButton?
    var friday: UIButton?
    var saturday: UIButton?

    fileprivate func setupGoalNameLabel() {
        goalNameLabel.text = "Goal Name"
        goalNameLabel.textColor = .black
        goalNameLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(goalNameLabel)

        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        goalNameLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30).isActive = true
        goalNameLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        goalNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        goalNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupGoalNameTextField() {
        goalNameTextField.delegate = self
        goalNameTextField.tag = 1
        goalNameTextField.borderStyle = .line
        view.addSubview(goalNameTextField)

        goalNameTextField.translatesAutoresizingMaskIntoConstraints = false
        goalNameTextField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        goalNameTextField.topAnchor.constraint(equalTo: goalNameLabel.bottomAnchor, constant: 10).isActive = true
        goalNameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        goalNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupGoalTypeLabel() {
        goalTypeLabel.text = "Goal Type"
        goalTypeLabel.textColor = .black
        goalTypeLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(goalTypeLabel)

        goalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        goalTypeLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        goalTypeLabel.topAnchor.constraint(equalTo: goalNameTextField.bottomAnchor, constant: 30).isActive = true
        goalTypeLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        goalTypeLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupGoalTypeTextField() {
        goalTypeTextField.delegate = self
        goalTypeTextField.tag = 2
        goalTypeTextField.borderStyle = .line
        view.addSubview(goalTypeTextField)

        goalTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        goalTypeTextField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        goalTypeTextField.topAnchor.constraint(equalTo: goalTypeLabel.bottomAnchor, constant: 10).isActive = true
        goalTypeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        goalTypeTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupGoalTypePickerView() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pickerViewDoneButtonTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        goalTypePickerView.delegate = self
        goalTypePickerView.dataSource = self
        goalTypeTextField.inputView = goalTypePickerView
        goalTypeTextField.inputAccessoryView = toolBar
    }

    fileprivate func setupTimesPerLabel() {
        timesPerLabel = UILabel()
        guard let timesPerLabel = timesPerLabel else { fatalError("Error in \(#function)") }

        if goal.goalType == 1 {
            timesPerLabel.text = "Times per week"
        } else if goal.goalType == 2 {
            timesPerLabel.text = "Times per day"
        } else {
            fatalError("Times per label")
        }

        timesPerLabel.textColor = .black
        timesPerLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(timesPerLabel)

        timesPerLabel.translatesAutoresizingMaskIntoConstraints = false
        timesPerLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        timesPerLabel.topAnchor.constraint(equalTo: goalTypeTextField.bottomAnchor, constant: 30).isActive = true
        timesPerLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        timesPerLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupTimesPerTextField() {
        timesPerTextField = UITextField()
        guard let timesPerTextField = timesPerTextField, let timesPerLabel = timesPerLabel else { fatalError(#function) }

        timesPerTextField.delegate = self
        timesPerTextField.tag = 3
        timesPerTextField.borderStyle = .line
        view.addSubview(timesPerTextField)

        timesPerTextField.translatesAutoresizingMaskIntoConstraints = false
        timesPerTextField.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        timesPerTextField.topAnchor.constraint(equalTo: timesPerLabel.bottomAnchor, constant: 10).isActive = true
        timesPerTextField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        timesPerTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupOnTheseDaysLabel() {
        onTheseDaysLabel = UILabel()
        guard let onTheseDaysLabel = onTheseDaysLabel, let timesPerTextField = timesPerTextField else { fatalError("Error in \(#function)") }

        onTheseDaysLabel.textColor = .black
        onTheseDaysLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(onTheseDaysLabel)

        onTheseDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        onTheseDaysLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        onTheseDaysLabel.topAnchor.constraint(equalTo: timesPerTextField.bottomAnchor, constant: 30).isActive = true
        onTheseDaysLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        onTheseDaysLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    fileprivate func setupWeekDays() {
        sunday = UIButton()
        monday = UIButton()
        tuesday = UIButton()
        wednesday = UIButton()
        thursday = UIButton()
        friday = UIButton()
        saturday = UIButton()

        guard let sunday = sunday, let monday = monday, let tuesday = tuesday, let wednesday = wednesday, let thursday = thursday, let friday = friday, let saturday = saturday, let onTheseDaysLabel = onTheseDaysLabel else { fatalError(#function) }
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

    fileprivate func setupSaveButton() {
        saveButton.setTitle("Save", for: .normal)
        saveButton.backgroundColor = .purple
        saveButton.addTarget(self, action: #selector(saveGoal(_:)), for: .touchUpInside)
        view.addSubview(saveButton)

        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        saveButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func goalTypeDidChange() {

        timesPerLabel?.removeFromSuperview()
        timesPerTextField?.removeFromSuperview()
        onTheseDaysLabel?.removeFromSuperview()
        sunday?.removeFromSuperview()
        monday?.removeFromSuperview()
        tuesday?.removeFromSuperview()
        wednesday?.removeFromSuperview()
        thursday?.removeFromSuperview()
        friday?.removeFromSuperview()
        saturday?.removeFromSuperview()

        setupGoalNameLabel()
        setupGoalNameTextField()
        setupGoalTypeLabel()
        setupGoalTypeTextField()
        setupGoalTypePickerView()

        switch goal.goalType {
        case 1:
            setupTimesPerLabel()
            setupTimesPerTextField()
        case 2:
            fallthrough
            //            setupTimesPerLabel()
            //            setupTimesPerTextField()
            //            setupOnTheseDaysLabel()
        //            setupWeekDays()
        default:
            break
        }
        setupSaveButton()
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

    func saveGoal(_ sender: UIButton) {
        let realm = try! Realm()

        guard let goalText = goalNameTextField.text else { return }
        let goal = Goal()
        goal.name = goalText
        goal.completed = false
        goal.dueDate = Date().nextSunday()

        switch goal.goalType {
        case 2:
            goal.goalType = 2
            /*guard let sunday = sunday, let monday = monday, let tuesday = tuesday, let wednesday = wednesday, let thursday = thursday, let friday = friday, let saturday = saturday else { fatalError(#function) }

             for button in [sunday, monday, tuesday, wednesday, thursday, friday, saturday].filter({ $0.tag == 2 }) {
             let weekday = Weekday()
             switch button.titleLabel!.text! {
             case "Su":
             weekday.name = "Sunday"
             case "M":
             weekday.name = "Monday"
             case "Tu":
             weekday.name = "Tuesday"
             case "W":
             weekday.name = "Wednesday"
             case "Th":
             weekday.name = "Thursday"
             case "F":
             weekday.name = "Friday"
             default:
             weekday.name = "Saturday"
             }
             goal.days.append(weekday)
             }
             fallthrough*/
        case 1:
            goal.goalType = 1
            goal.timesPer = Int16(timesPerTextField!.text!)!
        default:
            goal.goalType = 3
        }

        do {
            try realm.write {
                realm.add(goal)
                print("Saved Goal")
            }
        } catch {
            print("Can't save")
        }

        dismiss(animated: true, completion: nil)
    }
}

extension EditGoalViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
            goalTypeTextField.text = "Weekly"
            goal.goalType = 1
        case 1:
            goalTypeTextField.text = "Daily"
            goal.goalType = 2
        default:
            goalTypeTextField.text = "Once"
            goal.goalType = 3
        }
    }

    func pickerViewDoneButtonTapped() {
        view.endEditing(true)
    }
}
