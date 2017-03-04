//
//  GoalInfoViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/26/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class GoalInfoViewController: UIViewController {

    let goal: Goal

    init(goal: Goal) {
        self.goal = goal
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let goalNameLabel = UILabel()
        goalNameLabel.text = goal.name
        goalNameLabel.font = UIFont.systemFont(ofSize: 24)
        view.addSubview(goalNameLabel)

        goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
        goalNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goalNameLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        goalNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -50).isActive = true
        goalNameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let goalCompleteButton = UIButton()
        goalCompleteButton.setTitle("Complete Goal", for: .normal)
        goalCompleteButton.backgroundColor = .purple
        goalCompleteButton.addTarget(self, action: #selector(completeGoal(_:)), for: .touchUpInside)
        view.addSubview(goalCompleteButton)

        goalCompleteButton.translatesAutoresizingMaskIntoConstraints = false
        goalCompleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        goalCompleteButton.topAnchor.constraint(equalTo: goalNameLabel.bottomAnchor, constant: 10).isActive = true
        goalCompleteButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        goalCompleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let editGoalButton = UIButton()
        editGoalButton.setTitle("Edit Goal", for: .normal)
        editGoalButton.backgroundColor = .purple
        editGoalButton.addTarget(self, action: #selector(editGoal(_:)), for: .touchUpInside)
        view.addSubview(editGoalButton)

        editGoalButton.translatesAutoresizingMaskIntoConstraints = false
        editGoalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editGoalButton.topAnchor.constraint(equalTo: goalCompleteButton.bottomAnchor, constant: 10).isActive = true
        editGoalButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        editGoalButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func completeGoal(_ sender: UIButton) {
        goal.completed = true
    }

    func editGoal(_ sender: UIButton) {

    }

}
