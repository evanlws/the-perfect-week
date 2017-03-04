//
//  GoalNameViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit
import RealmSwift

class GoalNameViewController: UIViewController {

    @IBOutlet weak var goalNameTextField: UITextField!

    @IBAction func didTap(withSender saveButton: UIButton) {
        let realm = try! Realm()

        guard let goalText = goalNameTextField.text else { return }
        let goal = Goal()
        goal.name = goalText
        goal.completed = false
        goal.dueDate = Date().nextSunday()

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

extension GoalNameViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

