//
//  GoalsViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

let collectionViewInset: CGFloat = 10.0

final class GoalsViewController: UIViewController, UIGestureRecognizerDelegate {

	var viewModel: GoalsViewModel!
	let collectionView: UICollectionView

	init() {
		let collectionViewFlowLayout = UICollectionViewFlowLayout()
		collectionViewFlowLayout.scrollDirection = .vertical
		collectionViewFlowLayout.itemSize = CGSize(width: GoalCollectionViewCell.size.width, height: GoalCollectionViewCell.size.height)
		collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: collectionViewInset, left: collectionViewInset, bottom: collectionViewInset, right: collectionViewInset)
		collectionViewFlowLayout.minimumInteritemSpacing = 10.0
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupGestureRecognizer()
		setupCollectionView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData()
	}

	// MARK: - Setup
	private func setupCollectionView() {
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.bounces = true
		collectionView.alwaysBounceVertical = true
		collectionView.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GoalCollectionViewCell.self))
		view.addSubview(collectionView)

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: InformationHeader.windowSize.height).isActive = true
		collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
		collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
	}

	private func setupGestureRecognizer() {
		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(completeGoal(_:)))
		longPressGestureRecognizer.minimumPressDuration = 1.0
		longPressGestureRecognizer.delaysTouchesBegan = true
		longPressGestureRecognizer.delegate = self
		collectionView.addGestureRecognizer(longPressGestureRecognizer)
	}

	// MARK: - Navigation
	func presentGoalDetailVC(_ indexPathRow: Int) {
		let goalDetailViewController = GoalDetailViewController()
		goalDetailViewController.viewModel = GoalDetailViewModel(goal: viewModel.goals[indexPathRow])
		navigationController?.pushViewController(goalDetailViewController, animated: true)
	}

	func presentAddGoalVC(_ indexPathRow: Int) {
		let addGoalNameViewController = AddGoalNameViewController()
		addGoalNameViewController.viewModel = AddGoalNameViewModel(mutableGoal: MutableGoal(objectId: UUID().uuidString))
		let navigationController = UINavigationController(rootViewController: addGoalNameViewController)
		present(navigationController, animated: true) {
			self.collectionView.reloadData()
		}
	}

	func completeGoal(_ gestureRecognizer: UILongPressGestureRecognizer) {
		guard gestureRecognizer.state == .began else { return }

		let point = gestureRecognizer.location(in: collectionView)
		if let indexPath = collectionView.indexPathForItem(at: point) {
			let goal = viewModel.goals[indexPath.row] as Goal
			if goal.isCompleted {
				viewModel.undo(goal)
			} else {
				viewModel.complete(viewModel.goals[indexPath.row])
			}

			collectionView.reloadData()
		}
	}

}

extension GoalsViewController: UICollectionViewDataSource {

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return viewModel.goals.count + 1
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: GoalCollectionViewCell
		if let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoalCollectionViewCell.self), for: indexPath) as? GoalCollectionViewCell {
			cell = reusedCell
		} else {
			cell = GoalCollectionViewCell()
		}

		if indexPath.row == viewModel.goals.count {
			cell.nameLabel.text = "Add a goal"
		} else {
			let goal = viewModel.goals[indexPath.row]
			cell.setCompletedStyle(goal.isCompleted)
			cell.nameLabel.text = goal.name
		}

		return cell
	}

}

extension GoalsViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if indexPath.row == viewModel.goals.count {
			presentAddGoalVC(indexPath.row)
		} else {
			presentGoalDetailVC(indexPath.row)
		}
	}
}
