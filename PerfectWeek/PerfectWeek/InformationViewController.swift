//
//  InformationViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class InformationViewController: UIViewController {

	private let viewModel = InformationViewModel()

	private let progressView = ProgressView(height: Constraints.gridBlock * 9)

	private let multiplierLabel = Label(style: .body1)

	private let weekdayLabel: Label = {
		let label = Label(style: .heading1, alignment: .right)
		label.sizeToFit()
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let dateLabel: Label = {
		let label = Label(style: .heading2, alignment: .right)
		label.sizeToFit()
		label.adjustsFontSizeToFitWidth = true
		return label
	}()

	private let tipsLabel: Label = {
		let label = Label(style: .body4, alignment: .center)
		label.numberOfLines = 0
		label.sizeToFit()
		label.adjustsFontSizeToFitWidth = true
		label.text = "I'm sure I'll put content here eventually\n\t\t\t-Evan"
		return label
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
	}

	// MARK: - Setup
	private func configureViews() {
		view.addSubview(progressView)
		view.addSubview(multiplierLabel)
		view.addSubview(weekdayLabel)
		view.addSubview(dateLabel)
		view.addSubview(tipsLabel)
	}

	private func configureConstraints() {
		progressView.translatesAutoresizingMaskIntoConstraints = false
		multiplierLabel.translatesAutoresizingMaskIntoConstraints = false
		weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		tipsLabel.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + Constraints.gridBlock * 2),
			progressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constraints.gridBlock * 2),
			progressView.heightAnchor.constraint(equalToConstant: progressView.height),
			progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor),

			multiplierLabel.leftAnchor.constraint(equalTo: progressView.rightAnchor),
			multiplierLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor),

			weekdayLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + Constraints.gridBlock * 2),
			weekdayLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor),
			weekdayLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constraints.gridBlock * 2),

			dateLabel.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor),
			dateLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor),
			dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: progressView.bottomAnchor),
			dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constraints.gridBlock * 2),

			tipsLabel.topAnchor.constraint(greaterThanOrEqualTo: progressView.bottomAnchor, constant: Constraints.gridBlock),
			tipsLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constraints.gridBlock),
			tipsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constraints.gridBlock),
			tipsLabel.heightAnchor.constraint(equalToConstant: view.bounds.size.height / 3)
		])
	}

	func updateInformation() {
		multiplierLabel.text = viewModel.streak
		weekdayLabel.text = viewModel.weekday
		dateLabel.text = viewModel.date
		progressView.updateProgress(progress: viewModel.currentWeekProgress(), animated: true, completion: {})
	}

}
