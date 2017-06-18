//
//  StatsViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/11/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class StatsViewController: UIViewController {

	let viewModel: StatsViewModel

	fileprivate let pageControl = UIPageControl()
	private let graphReportScrollView = UIScrollView()
	private let statsTableView = UITableView()
	private let graphView = ScrollableGraphView()
	private let reportView = ReportView()

	init(viewModel: StatsViewModel) {
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
		viewModel.updateStats()
		configureStats()
	}

	private func configureViews() {
		pageControl.numberOfPages = 2
		pageControl.currentPage = 0
		pageControl.currentPageIndicatorTintColor = ColorLibrary.UIPalette.primary
		pageControl.pageIndicatorTintColor = ColorLibrary.BlackAndWhite.gray1

		graphReportScrollView.frame = CGRect(x: 0, y: InformationHeader.windowSize.height, width: self.view.frame.width, height: Constraints.gridBlock * 28)
		graphReportScrollView.contentSize = CGSize(width: graphReportScrollView.frame.size.width * 2, height: graphReportScrollView.frame.size.height)
		graphReportScrollView.showsHorizontalScrollIndicator = false
		graphReportScrollView.delegate = self

		graphView.frame = CGRect(x: 0, y: 0, width: graphReportScrollView.frame.width, height: graphReportScrollView.frame.height)
		graphView.dataPointFillColor = ColorLibrary.UIPalette.primary
		graphView.lineColor = ColorLibrary.BlackAndWhite.gray1
		reportView.frame = CGRect(x: graphReportScrollView.frame.width, y: 0, width: graphReportScrollView.frame.width, height: graphReportScrollView.frame.height)

		statsTableView.dataSource = self
		statsTableView.register(StatTableViewCell.self, forCellReuseIdentifier: String(describing: StatTableViewCell.self))
		statsTableView.alwaysBounceVertical = false

		graphReportScrollView.addSubview(graphView)
		graphReportScrollView.addSubview(reportView)
		view.addSubview(graphReportScrollView)
		view.addSubview(pageControl)
		view.addSubview(statsTableView)
	}

	private func configureStats() {
		graphView.set(data: viewModel.graphData, withLabels: viewModel.graphLabels)
		statsTableView.reloadData()

		if viewModel.dateRange.isBlank {
			graphReportScrollView.isScrollEnabled = false
			pageControl.isHidden = true
		}

		reportView.dateRangeLabel.text = viewModel.dateRange
		reportView.goalsCompleted.text = viewModel.goalsCompleted
		reportView.results.text = viewModel.results
		reportView.suggestion.text = viewModel.suggestion
	}

	private func configureConstraints() {
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		statsTableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pageControl.topAnchor.constraint(equalTo: graphReportScrollView.bottomAnchor),
			statsTableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor),
			statsTableView.leftAnchor.constraint(equalTo: graphReportScrollView.leftAnchor),
			statsTableView.rightAnchor.constraint(equalTo: graphReportScrollView.rightAnchor),
			statsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		])
	}

}

extension StatsViewController: UIScrollViewDelegate {

	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageWidth: CGFloat = scrollView.frame.width
		let currentPage: CGFloat = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
		pageControl.currentPage = Int(currentPage)
	}

}

extension StatsViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.statsTableViewItems.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: StatTableViewCell.self)) as? StatTableViewCell else { fatalError(guardFailureWarning("Could not dequeue cell")) }

		let statsItem = viewModel.statsTableViewItems[indexPath.row]
		cell.textLabel?.text = statsItem.title
		cell.detailTextLabel?.text = "\(statsItem.detail)"
		cell.detailTextLabel?.textColor = .black
		return cell
	}

}

class StatTableViewCell: UITableViewCell {

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .value1, reuseIdentifier: reuseIdentifier)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

final class ReportView: UIView {

	fileprivate let lastWeekReportLabel = Label(style: .body1, color: ColorLibrary.BlackAndWhite.white)
	fileprivate let dateRangeLabel = Label(style: .body4, color: ColorLibrary.BlackAndWhite.white)
	fileprivate let goalsCompletedLabel = Label(style: .body1, color: ColorLibrary.BlackAndWhite.white)
	fileprivate let goalsCompleted = Label(style: .body4, color: ColorLibrary.BlackAndWhite.white)
	fileprivate let results = Label(style: .body1, color: ColorLibrary.BlackAndWhite.white)
	fileprivate let suggestion = Label(style: .body1, color: ColorLibrary.BlackAndWhite.white)

	fileprivate let backgroundView = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		configureViews()
		configureConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func configureViews() {
		backgroundView.backgroundColor = ColorLibrary.UIPalette.accent

		lastWeekReportLabel.text = LocalizedStrings.lastWeekReport
		goalsCompletedLabel.text = LocalizedStrings.goalsCompleted
		goalsCompletedLabel.textAlignment = .left
		results.minimumScaleFactor = 0.8
		results.adjustsFontSizeToFitWidth = true
		results.sizeToFit()

		addSubview(backgroundView)
		backgroundView.addSubview(lastWeekReportLabel)
		backgroundView.addSubview(dateRangeLabel)
		backgroundView.addSubview(goalsCompletedLabel)
		backgroundView.addSubview(goalsCompleted)
		backgroundView.addSubview(results)
		backgroundView.addSubview(suggestion)
	}

	private func configureConstraints() {
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		lastWeekReportLabel.translatesAutoresizingMaskIntoConstraints = false
		dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
		goalsCompletedLabel.translatesAutoresizingMaskIntoConstraints = false
		goalsCompleted.translatesAutoresizingMaskIntoConstraints = false
		results.translatesAutoresizingMaskIntoConstraints = false
		suggestion.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			backgroundView.topAnchor.constraint(equalTo: topAnchor, constant: Constraints.gridBlock),
			backgroundView.leftAnchor.constraint(equalTo: leftAnchor, constant: Constraints.gridBlock),
			backgroundView.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constraints.gridBlock),
			backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constraints.gridBlock),

			lastWeekReportLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
			lastWeekReportLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: Constraints.gridBlock),

			dateRangeLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
			dateRangeLabel.topAnchor.constraint(equalTo: lastWeekReportLabel.bottomAnchor),

			goalsCompletedLabel.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: Constraints.gridBlock * 2),
			goalsCompletedLabel.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: Constraints.gridBlock * 2),
			goalsCompletedLabel.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),

			goalsCompleted.topAnchor.constraint(equalTo: goalsCompletedLabel.bottomAnchor),
			goalsCompleted.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: Constraints.gridBlock * 2),
			goalsCompleted.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),

			results.topAnchor.constraint(equalTo: goalsCompleted.bottomAnchor, constant: Constraints.gridBlock * 2),
			results.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
			results.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: Constraints.gridBlock),
			results.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -Constraints.gridBlock),

			suggestion.topAnchor.constraint(equalTo: results.bottomAnchor, constant: Constraints.gridBlock * 2),
			suggestion.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
			suggestion.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: Constraints.gridBlock),
			suggestion.rightAnchor.constraint(equalTo: backgroundView.rightAnchor, constant: -Constraints.gridBlock),
			suggestion.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -Constraints.gridBlock * 2)
		])
	}

}
