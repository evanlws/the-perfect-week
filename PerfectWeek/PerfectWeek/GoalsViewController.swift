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

	let viewModel: GoalsViewModel
	let collectionView: UICollectionView

	init(viewModel: GoalsViewModel) {
		self.viewModel = viewModel
		let collectionViewFlowLayout = UICollectionViewFlowLayout()
		collectionViewFlowLayout.scrollDirection = .vertical
		collectionViewFlowLayout.itemSize = CGSize(width: GoalCollectionViewCell.size.width, height: GoalCollectionViewCell.size.height)
		collectionViewFlowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
		collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: collectionViewInset, left: collectionViewInset, bottom: collectionViewInset, right: collectionViewInset)
		collectionViewFlowLayout.minimumInteritemSpacing = 10.0
		self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
		super.init(nibName: nil, bundle: nil)

		viewModel.addNewGoalButtonCallback = { [weak self] in
			self?.didTapNewGoalButton()
		}
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
		collectionView.dataSource = viewModel
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
		let addGoalNameViewModel = AddGoalNameViewModel(mutableGoal: MutableGoal(objectId: UUID().uuidString))
		let addGoalNameViewController = AddGoalNameViewController(viewModel: addGoalNameViewModel)
		let navigationController = UINavigationController(rootViewController: addGoalNameViewController)
		present(navigationController, animated: true) {
			self.collectionView.reloadData()
		}
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
		if let indexPath = collectionView.indexPathForItem(at: point), let goal = viewModel.objectAt(indexPath), goal.progress != goal.frequency {
			viewModel.complete(goal)
			collectionView.reloadData()
		}
	}
}

// MARK: - Navigation
extension GoalsViewController {

	func presentGoalDetailVC(_ goal: Goal) {
		let goalDetailViewController = GoalDetailViewController(viewModel: GoalDetailViewModel(goal: goal))
		navigationController?.pushViewController(goalDetailViewController, animated: true)
	}

}

extension GoalsViewController: UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard let goal = viewModel.objectAt(indexPath) else { return }
		presentGoalDetailVC(goal)
	}

}
