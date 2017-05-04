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
	let tableView = UITableView(frame: .zero)

	override func viewDidLoad() {
		super.viewDidLoad()
		let cancelButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel(_:)))
		navigationItem.leftBarButtonItem = cancelButtonItem
		setupTableView()
	}

	private func setupTableView() {
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
		let editGoalViewController = EditGoalViewController()
		editGoalViewController.viewModel = EditGoalViewModel(goal: viewModel.goal)
		navigationController?.pushViewController(editGoalViewController, animated: true)
	}

	func cancel(_ barButtonItem: UIBarButtonItem) {
		_ = navigationController?.popToRootViewController(animated: true)
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
			cell.textLabel?.text = viewModel.goal.name
		default:
			cell.textLabel?.text = String(viewModel.goal.frequency)
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
			viewModel.delete(viewModel.goal)
			_ = navigationController?.popToRootViewController(animated: true)
		default:
			break
		}

	}

}
