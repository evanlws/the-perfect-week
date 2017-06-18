//
//  GoalDetailViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/20/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalDetailViewController: UIViewController {

	var viewModel: GoalDetailViewModel

	private let backButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitle(LocalizedStrings.back, for: .normal)
		button.setTitleColor(ColorLibrary.UIPalette.primary, for: .normal)
		button.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
		return button
	}()

	private let editGoalButton: UIButton = {
		let button = UIButton(type: .custom)
		button.setTitle(LocalizedStrings.editGoal, for: .normal)
		button.setTitleColor(ColorLibrary.UIPalette.primary, for: .normal)
		button.addTarget(self, action: #selector(didTapEditGoal), for: .touchUpInside)
		return button
	}()

	private let completeGoalButton: UIButton = {
		let button = Button.initialize(type: .basicBox)
		button.setTitle(LocalizedStrings.completeGoal, for: .normal)
		button.addTarget(self, action: #selector(didTapCompleteGoal), for: .touchUpInside)
		return button
	}()

	private let detailContentView: DetailContentView = {
		let view = DetailContentView(frame: .zero)
		view.backgroundColor = .white
		view.layer.shadowColor = UIColor.black.cgColor
		view.layer.shadowOffset = CGSize(width: 0, height: 1)
		view.layer.shadowOpacity = 1
		view.layer.shadowRadius = 1.0
		view.clipsToBounds = false
		view.layer.masksToBounds = false
		return view
	}()

	init(viewModel: GoalDetailViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureViews()
		configureConstraints()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		InformationHeaderObserver.shouldShowInformationHeader()
		navigationController?.setNavigationBarHidden(true, animated: true)
	}

	private func configureViews() {
		view.backgroundColor = .white
		view.addSubview(backButton)
		view.addSubview(editGoalButton)
		view.addSubview(detailContentView)
		view.addSubview(completeGoalButton)
		detailContentView.progressView.updateProgress(progress: viewModel.goal.currentProgressPercentage(), animated: false, completion: {})

		detailContentView.goalNameLabel.text = viewModel.goal.name
		detailContentView.frequencyNumberLabel.text = "\(viewModel.goal.frequency)"
		detailContentView.completionsThisWeekNumberLabel.text = "\(viewModel.goal.progress)"
		detailContentView.currentStreakNumberLabel.text = "\(viewModel.goal.currentStreak)"
		detailContentView.goalNotesTextView.text = viewModel.goal.notes
	}

	private func configureConstraints() {
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

// MARK: - Actions
extension GoalDetailViewController {

	func didTapBack() {
		presentGoalsVC()
	}

	func didTapEditGoal() {
		presentEditGoalVC()
	}

	func didTapCompleteGoal() {
		viewModel.completeGoal()
		presentGoalsVC()
	}

}

// MARK: - Navigation
extension GoalDetailViewController {

	fileprivate func presentEditGoalVC() {
		let editGoalViewController = EditGoalViewController(viewModel: EditGoalViewModel(goal: viewModel.goal))
		navigationController?.pushViewController(editGoalViewController, animated: true)
	}

	fileprivate func presentGoalsVC() {
		_ = navigationController?.popToRootViewController(animated: true)
	}

}

final class DetailContentView: UIView {

	fileprivate let goalNameLabel = Label(style: .body2)

	fileprivate let progressView = ProgressView(height: Constraints.gridBlock * 6)

	private let frequencyLabel: Label = {
		let label = Label(style: .body4)
		label.text = LocalizedStrings.frequency
		return label
	}()

	fileprivate let frequencyNumberLabel = Label(style: .body4)

	private let completionsThisWeekLabel: Label = {
		let label = Label(style: .body4)
		label.text = LocalizedStrings.completionsThisWeek
		return label
	}()

	fileprivate let completionsThisWeekNumberLabel = Label(style: .body4)

	private let currentStreakLabel: Label = {
		let label = Label(style: .body4)
		label.text = LocalizedStrings.currentStreak
		return label
	}()

	fileprivate let currentStreakNumberLabel = Label(style: .body4)

	fileprivate let goalNotesTextView: UITextView = {
		let textView = UITextView()
		textView.font = UIFont.systemFont(ofSize: 15.0)
		textView.textColor = .darkGray
		textView.isEditable = false
		textView.isSelectable = false
		textView.textAlignment = .center
		return textView
	}()

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
		addSubview(frequencyLabel)
		addSubview(frequencyNumberLabel)
		addSubview(completionsThisWeekLabel)
		addSubview(completionsThisWeekNumberLabel)
		addSubview(currentStreakLabel)
		addSubview(currentStreakNumberLabel)
		addSubview(goalNotesTextView)
	}

	private func configureConstraints() {
		goalNameLabel.translatesAutoresizingMaskIntoConstraints = false
		progressView.translatesAutoresizingMaskIntoConstraints = false
		goalNotesTextView.translatesAutoresizingMaskIntoConstraints = false
		frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
		frequencyNumberLabel.translatesAutoresizingMaskIntoConstraints = false
		completionsThisWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		completionsThisWeekNumberLabel.translatesAutoresizingMaskIntoConstraints = false
		currentStreakLabel.translatesAutoresizingMaskIntoConstraints = false
		currentStreakNumberLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			goalNameLabel.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
			goalNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.gridBlock * 2),
			goalNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: progressView.leadingAnchor),

			progressView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gridBlock * 2),
			progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.gridBlock * 2),
			progressView.heightAnchor.constraint(equalToConstant: progressView.height),
			progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),

			frequencyLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: Constraints.gridBlock),
			frequencyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.gridBlock),

			frequencyNumberLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: Constraints.gridBlock),
			frequencyNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.gridBlock),
			frequencyNumberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: frequencyLabel.trailingAnchor, constant: Constraints.gridBlock),

			completionsThisWeekLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: Constraints.gridBlock),
			completionsThisWeekLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.gridBlock),

			completionsThisWeekNumberLabel.topAnchor.constraint(equalTo: frequencyLabel.bottomAnchor, constant: Constraints.gridBlock),
			completionsThisWeekNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.gridBlock),
			completionsThisWeekNumberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: completionsThisWeekLabel.trailingAnchor, constant: Constraints.gridBlock),

			currentStreakLabel.topAnchor.constraint(equalTo: completionsThisWeekLabel.bottomAnchor, constant: Constraints.gridBlock),
			currentStreakLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.gridBlock),

			currentStreakNumberLabel.topAnchor.constraint(equalTo: completionsThisWeekLabel.bottomAnchor, constant: Constraints.gridBlock),
			currentStreakNumberLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.gridBlock),
			currentStreakNumberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: currentStreakLabel.trailingAnchor, constant: Constraints.gridBlock),

			goalNotesTextView.topAnchor.constraint(equalTo: currentStreakLabel.bottomAnchor, constant: Constraints.gridBlock),
			goalNotesTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constraints.gridBlock),
			goalNotesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constraints.gridBlock),
			goalNotesTextView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor)
		])
	}

}
