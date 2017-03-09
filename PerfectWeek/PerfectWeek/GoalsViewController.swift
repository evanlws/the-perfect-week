//
//  GoalsViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

	var dataSource: GoalsViewModel

	init() {
		self.dataSource = GoalsViewModel()
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupCollectionView()
	}

	fileprivate func setupCollectionView() {
		let collectionViewFlowLayout = UICollectionViewFlowLayout()
		collectionViewFlowLayout.itemSize = CGSize(width: 170, height: 125)
		collectionViewFlowLayout.scrollDirection = .vertical
		collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
		collectionViewFlowLayout.minimumInteritemSpacing = 10.0

		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.bounces = true
		collectionView.alwaysBounceVertical = true
		collectionView.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GoalCollectionViewCell.self))
		view.addSubview(collectionView)

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

}

extension GoalsViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource.goals.count + 1
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: GoalCollectionViewCell
		if let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoalCollectionViewCell.self), for: indexPath) as? GoalCollectionViewCell {
			cell = reusedCell
		} else {
			cell = GoalCollectionViewCell()
		}

		if indexPath.row == dataSource.goals.count {
			cell.nameLabel.text = "Add a goal"
		} else {
			let goal = dataSource.goals[indexPath.row]
			cell.setCompletedStyle(goal.isCompleted)
			cell.nameLabel.text = goal.name
		}

		return cell
	}

}

extension GoalsViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row == dataSource.goals.count {
			let navigationController = UINavigationController(rootViewController: AddGoalNameViewController())
			present(navigationController, animated: true) {
				collectionView.reloadData()
			}
		} else {
			dataSource.complete(dataSource.goals[indexPath.row])
			collectionView.reloadData()
		}
	}
}
