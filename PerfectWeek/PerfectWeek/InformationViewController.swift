//
//  InformationViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class InformationViewController: UIViewController {

	private let progressView = ProgressView()

	private let multiplierLabel: UILabel = {
		let label = UILabel()
		label.text = "x\(StatsLibrary.shared.stats.currentStreak)"
		label.font = UIFont.systemFont(ofSize: 23)
		return label
	}()

	private let weekdayLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 36)
		label.textColor = .black
		label.textAlignment = .right
		label.sizeToFit()
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let dateLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 20)
		label.textColor = .black
		label.textAlignment = .right
		label.sizeToFit()
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let tipsPagingView = UIView()

	private let tipsLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14)
		label.textColor = .black
		label.numberOfLines = 0
		label.textAlignment = .center
		label.sizeToFit()
		label.adjustsFontSizeToFitWidth = true
		label.text = "I'm sure I'll put content here eventually\n\t\t\t-Evan"
		return label
	}()

	private let bottomLine: UIView = {
		let view = UIView()
		view.backgroundColor = .lightGray
		return view
	}()

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureViews()
		configureConstraints()
		updateInformation()
	}

	// MARK: - Setup
	private func configureViews() {
		view.addSubview(progressView)
		view.addSubview(multiplierLabel)
		view.addSubview(weekdayLabel)
		view.addSubview(dateLabel)
		view.addSubview(tipsPagingView)
		view.addSubview(tipsLabel)
		view.addSubview(bottomLine)
	}

	private func configureConstraints() {
		progressView.translatesAutoresizingMaskIntoConstraints = false
		multiplierLabel.translatesAutoresizingMaskIntoConstraints = false
		weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		tipsPagingView.translatesAutoresizingMaskIntoConstraints = false
		tipsLabel.translatesAutoresizingMaskIntoConstraints = false
		bottomLine.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + 5.0),
			progressView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
			progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),
			multiplierLabel.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: 5.0),
			multiplierLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor),
			weekdayLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + 5.0),
			weekdayLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor),
			weekdayLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
			dateLabel.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 2.0),
			dateLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor),
			dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: progressView.bottomAnchor),
			dateLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
			tipsPagingView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5.0),
			tipsPagingView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
			tipsPagingView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -5.0),
			tipsPagingView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
			tipsPagingView.heightAnchor.constraint(equalToConstant: view.bounds.size.height/3),
			tipsLabel.topAnchor.constraint(equalTo: tipsPagingView.topAnchor, constant: 5.0),
			tipsLabel.leftAnchor.constraint(equalTo: tipsPagingView.leftAnchor, constant: 5.0),
			tipsLabel.bottomAnchor.constraint(equalTo: tipsPagingView.bottomAnchor, constant: 5.0),
			tipsLabel.rightAnchor.constraint(equalTo: tipsPagingView.rightAnchor, constant: 5.0),
			bottomLine.heightAnchor.constraint(equalToConstant: 2.0),
			bottomLine.widthAnchor.constraint(equalTo: view.widthAnchor),
			bottomLine.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

	func updateInformation() {
		multiplierLabel.text = "x\(StatsLibrary.shared.stats.currentStreak)"
		let dateItems = currentDate()
		weekdayLabel.text = dateItems.weekday
		dateLabel.text = dateItems.date
		progressView.updateProgress(progress: currentWeekProgress())
	}

	private func currentDate() -> (date: String, weekday: String) {
		let currentDate = Date()
		let locale = Locale.autoupdatingCurrent
		let weekdayDateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: locale)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = weekdayDateFormat
		let weekday = dateFormatter.string(from: currentDate)

		let dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM", options: 0, locale: locale)
		dateFormatter.dateFormat = dateFormat
		let date = dateFormatter.string(from: currentDate)

		return (date, weekday)
	}

	private func currentWeekProgress() -> Int {
		let goals = GoalLibrary.shared.goals
		guard goals.count > 0 else { return 0 }
		let totalProgress = goals.reduce(0, { $0 + $1.progress })
		let totalFrequency = goals.reduce(0, { $0 + $1.frequency })
		return Int(Float(totalProgress) / Float(totalFrequency) * 100.0)
	}

}
