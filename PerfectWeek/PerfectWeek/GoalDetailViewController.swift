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

		let detailContentView = DetailContentView(frame: .zero)
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

final class DetailContentView: UIView {

	fileprivate let goalNameLabel: Label = {
		let label = Label(style: .body)
		label.text = "Read a book"
		return label
	}()

	fileprivate let goalDescriptionLabel: Label = {
		let label = Label(style: .body)
		label.text = "Maybe a couple chapters of 1984. Or anything else that looks interesting."
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()

	private let frequencyLabel: Label = {
		let label = Label(style: .body)
		label.text = "Frequency"
		return label
	}()

	fileprivate let frequencyNumberLabel: Label = {
		let label = Label(style: .body)
		label.text = "4 times per week"
		label.textAlignment = .right
		return label
	}()

	private let completionsThisWeekLabel: Label = {
		let label = Label(style: .body)
		label.text = "Completions this week"
		return label
	}()

	fileprivate let completionsThisWeekNumberLabel: Label = {
		let label = Label(style: .body)
		label.text = "2"
		label.textAlignment = .right
		return label
	}()

	fileprivate let currentStreakNumberLabel: Label = {
		let label = Label(style: .body)
		label.text = "4"
		label.textAlignment = .right
		return label
	}()

	private let currentStreakLabel: Label = {
		let label = Label(style: .body)
		label.text = "Current Streak"
		return label
	}()

	fileprivate let progressView = ProgressView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
		configureConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureViews() {
		addSubview(goalNameLabel)
		addSubview(progressView)
		addSubview(goalDescriptionLabel)
		addSubview(frequencyLabel)
		addSubview(frequencyNumberLabel)
		addSubview(completionsThisWeekLabel)
		addSubview(completionsThisWeekNumberLabel)
		addSubview(currentStreakLabel)
		addSubview(currentStreakNumberLabel)
	}

	private func configureConstraints() {
		goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
		progressView.translatesAutoresizingMaskIntoConstraints = false
		goalDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
		frequencyNumberLabel.translatesAutoresizingMaskIntoConstraints = false
		completionsThisWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		completionsThisWeekNumberLabel.translatesAutoresizingMaskIntoConstraints = false
		currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
		currentStreakNumberLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			goalNameLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
			goalNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0),
			progressView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
			progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0),
			progressView.widthAnchor.constraint(equalToConstant: 48),
			progressView.heightAnchor.constraint(equalToConstant: 48),
			goalDescriptionLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5.0),
			goalDescriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
			goalDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
			frequencyLabel.topAnchor.constraint(equalTo: goalDescriptionLabel.bottomAnchor, constant: 20.0),
			frequencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
			frequencyNumberLabel.topAnchor.constraint(equalTo: goalDescriptionLabel.bottomAnchor, constant: 20.0),
			frequencyNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
			frequencyNumberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: frequencyLabel.trailingAnchor, constant: 5.0),
			completionsThisWeekLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 10.0),
			completionsThisWeekLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
			completionsThisWeekNumberLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: 10.0),
			completionsThisWeekNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
			completionsThisWeekNumberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: completionsThisWeekLabel.trailingAnchor, constant: 5.0),
			currentStreakLabel.topAnchor.constraint(equalTo: completionsThisWeekLabel.bottomAnchor, constant: 10.0),
			currentStreakLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0),
			currentStreakNumberLabel.topAnchor.constraint(equalTo: completionsThisWeekLabel.bottomAnchor, constant: 10.0),
			currentStreakNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0),
			currentStreakNumberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: currentStreakLabel.trailingAnchor, constant: 5.0),
			currentStreakNumberLabel.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor)
		])
	}

}
