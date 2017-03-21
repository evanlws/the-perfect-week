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

	init(goal: Goal) {
		self.dataSource = GoalDetailViewModel(goal)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}

	fileprivate func setupTableView() {
		let tableView = UITableView(frame: .zero)
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

}

extension GoalDetailViewController: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
		cell.textLabel?.text = "Delete Goal"
		return cell
	}

}

extension GoalDetailViewController: UITableViewDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.row == 0 else { return }

		dataSource.delete(dataSource.goal)
		dismiss(animated: true, completion: nil)
	}

}
