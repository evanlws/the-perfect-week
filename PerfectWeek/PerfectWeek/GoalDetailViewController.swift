//
//  GoalDetailViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/20/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class GoalDetailViewController: UIViewController {

	var dataSource: GoalDetailViewModel
	let tableView = UITableView(frame: .zero)

	init(goal: Goal) {
		self.dataSource = GoalDetailViewModel(goal)
		super.init(nibName: nil, bundle: nil)
		let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
		navigationItem.leftBarButtonItem = cancelButtonItem
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}

	fileprivate func setupTableView() {
		tableView.backgroundColor = .white
		tableView.delegate = self
		tableView.dataSource = self
		tableView.bounces = false
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
		view.addSubview(tableView)

		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

	// MARK: - Navigation
	func pressentEditGoalVC() {
		let editGoalDataSource = EditGoalDataSource(goal: self.dataSource.goal)
		let editGoalViewController = EditGoalViewController(dataSource: editGoalDataSource)
		let navigationController = UINavigationController(rootViewController: editGoalViewController)
		present(navigationController, animated: true) {
			self.tableView.reloadData()
		}
	}

	func cancel(_ barButtonItem: UIBarButtonItem) {
		dismiss(animated: true, completion: nil)
	}

}

extension GoalDetailViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)

		switch indexPath.row {
		case 0:
			cell.textLabel?.text = "Edit Goal"
		case 1:
			cell.textLabel?.text = "Delete Goal"
		case 2:
			cell.textLabel?.text = dataSource.goal.name
		default:
			if dataSource.goal.frequency.type == .weekly {
				if let weekly = dataSource.goal.frequency as? Weekly {
					cell.textLabel?.text = String(weekly.timesPerWeek)
				}
			}
		}

		return cell
	}

}

extension GoalDetailViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch indexPath.row {
		case 0:
			pressentEditGoalVC()
		case 1:
			dataSource.delete(dataSource.goal)
			dismiss(animated: true, completion: nil)
		default:
			dismiss(animated: true, completion: nil)
		}

	}

}
