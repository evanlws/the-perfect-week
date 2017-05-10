//
//  GoalDetailViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/20/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalDetailViewController: UIViewController {

	var viewModel: GoalDetailViewModel!

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		configureViews()
	}

	private func configureViews() {
		let backButton = UIButton(type: .custom)
		backButton.setTitle("Back", for: .normal)
		backButton.setTitleColor(.purple, for: .normal)
		backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

		let editGoalButton = UIButton(type: .custom)
		editGoalButton.setTitle("Edit Goal", for: .normal)
		editGoalButton.setTitleColor(.purple, for: .normal)
		editGoalButton.addTarget(self, action: #selector(didTapEditGoal), for: .touchUpInside)

		let completeGoalButton = UIButton(style: .custom)
		completeGoalButton.setTitle("Complete  Goal", for: .normal)
		completeGoalButton.addTarget(self, action: #selector(didTapCompleteGoal), for: .touchUpInside)

		let detailContentView = UIView(frame: .zero)
		detailContentView.backgroundColor = .white
		detailContentView.layer.shadowColor = UIColor.black.cgColor
		detailContentView.layer.shadowOffset = CGSize(width: 0, height: 1)
		detailContentView.layer.shadowOpacity = 1
		detailContentView.layer.shadowRadius = 1.0
		detailContentView.clipsToBounds = false
		detailContentView.layer.masksToBounds = false

		view.addSubview(backButton)
		view.addSubview(editGoalButton)
		view.addSubview(detailContentView)
		view.addSubview(completeGoalButton)

		backButton.translatesAutoresizingMaskIntoConstraints = false
		editGoalButton.translatesAutoresizingMaskIntoConstraints = false
		detailContentView.translatesAutoresizingMaskIntoConstraints = false
		completeGoalButton.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: InformationHeader.windowSize.height + 10.0),
			backButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
			editGoalButton.topAnchor.constraint(equalTo: view.topAnchor, constant: InformationHeader.windowSize.height + 10.0),
			editGoalButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
			detailContentView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 10.0),
			detailContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			detailContentView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -20.0),
			detailContentView.heightAnchor.constraint(equalToConstant: 210.0),
			completeGoalButton.topAnchor.constraint(equalTo: detailContentView.bottomAnchor, constant: 30.0),
			completeGoalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			completeGoalButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -100.0)
		])
	}

}

// MARK: - Navigation
extension GoalDetailViewController {

	private func presentEditGoalVC() {
		let editGoalViewController = EditGoalViewController()
		editGoalViewController.viewModel = EditGoalViewModel(goal: viewModel.goal)
		navigationController?.pushViewController(editGoalViewController, animated: true)
	}

	func didTapBack() {
		_ = navigationController?.popToRootViewController(animated: true)
	}

	func didTapEditGoal() {
		presentEditGoalVC()
	}

	func didTapCompleteGoal() {
		viewModel.completeGoal()
		_ = navigationController?.popViewController(animated: true)
	}

}
