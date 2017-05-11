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
		collectionViewFlowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
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
		configureGestureRecognizer()
		configureViews()
		configureConstraints()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		InformationHeaderObserver.shouldShowInformationHeader()
		collectionView.reloadData()
	}

	// MARK: - Setup
	private func configureViews() {
		collectionView.backgroundColor = .white
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.bounces = true
		collectionView.alwaysBounceVertical = true

		collectionView.register(GoalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: GoalCollectionViewCell.self))
		collectionView.register(AddGoalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AddGoalCollectionViewCell.self))
		collectionView.register(GoalsCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: GoalsCollectionViewHeader.self))

		view.addSubview(collectionView)
	}

	private func configureConstraints() {
		collectionView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: InformationHeader.windowSize.height),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
	}

	private func configureGestureRecognizer() {
		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didActivateLongPress(_:)))
		longPressGestureRecognizer.minimumPressDuration = 1.0
		longPressGestureRecognizer.delaysTouchesBegan = true
		longPressGestureRecognizer.delegate = self
		collectionView.addGestureRecognizer(longPressGestureRecognizer)
	}

	fileprivate func presentAddGoalNameViewController() {
		let addGoalNameViewController = AddGoalNameViewController()
		addGoalNameViewController.viewModel = AddGoalNameViewModel(mutableGoal: MutableGoal(objectId: UUID().uuidString))
		let navigationController = UINavigationController(rootViewController: addGoalNameViewController)
		present(navigationController, animated: true) {
			self.collectionView.reloadData()
		}
	}

	fileprivate func complete(_ goal: Goal) {
		viewModel.complete(goal)
	}

	fileprivate func undo(_ goal: Goal) {
		viewModel.undo(goal)
	}
}

// MARK: - Actions
extension GoalsViewController {

	func didTapNewGoalButton() {
		presentAddGoalNameViewController()
	}

	func didActivateLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
		guard gestureRecognizer.state == .began else { return }

		let point = gestureRecognizer.location(in: collectionView)
		if let indexPath = collectionView.indexPathForItem(at: point), let goal = viewModel.objectAt(indexPath) {
			if goal.progress == goal.frequency {
				complete(goal)
			} else {
				undo(goal)
			}

			collectionView.reloadData()
		}
	}
}

// MARK: - Navigation
extension GoalsViewController {

	func presentGoalDetailVC(_ goal: Goal) {
		let goalDetailViewController = GoalDetailViewController()
		goalDetailViewController.viewModel = GoalDetailViewModel(goal: goal)
		navigationController?.pushViewController(goalDetailViewController, animated: true)
	}

}

extension GoalsViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel.numberOfSections
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionElementKindSectionHeader else { return UICollectionReusableView() }

		if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: GoalsCollectionViewHeader.self), for: indexPath) as? GoalsCollectionViewHeader {
			if indexPath.section == 1 {
				header.nameLabel.text = LocalizedStrings.goalsCompleted
			} else {
				header.nameLabel.text = LocalizedStrings.goalsToComplete
			}

			return header
		}

		return UICollectionReusableView()
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if section == 0 {
			return viewModel.goalsToComplete.count + 1
		}

		return viewModel.goalsCompletedToday.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

		if let goal = viewModel.objectAt(indexPath) {
			let cell: GoalCollectionViewCell
			if let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoalCollectionViewCell.self), for: indexPath) as? GoalCollectionViewCell {
				cell = reusedCell
			} else {
				cell = GoalCollectionViewCell()
			}

			cell.nameLabel.text = goal.name
			cell.progressView.updateProgress(progress: goal.currentProgress())
			return cell

		} else if indexPath.section == 0, indexPath.row == viewModel.goalsToComplete.count {
			let cell: AddGoalCollectionViewCell
			if let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddGoalCollectionViewCell.self), for: indexPath) as? AddGoalCollectionViewCell {
				cell = reusedCell
			} else {
				cell = AddGoalCollectionViewCell()
			}

			cell.newGoalButton.addTarget(self, action: #selector(didTapNewGoalButton), for: .touchUpInside)
			return cell
		}

		return UICollectionViewCell()
	}
}

extension GoalsViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let goal = viewModel.objectAt(indexPath) else { return }
		presentGoalDetailVC(goal)
	}

}
