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
		setupGestureRecognizer()
		setupCollectionView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		InformationHeaderObserver.shouldShowInformationHeader()
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
		collectionView.register(AddGoalCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: AddGoalCollectionViewCell.self))
		collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: String(describing: CollectionViewHeader.self))

		view.addSubview(collectionView)

		collectionView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: InformationHeader.windowSize.height),
			collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
			collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
	}

	private func setupGestureRecognizer() {
		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didActivateLongPress(_:)))
		longPressGestureRecognizer.minimumPressDuration = 1.0
		longPressGestureRecognizer.delaysTouchesBegan = true
		longPressGestureRecognizer.delegate = self
		collectionView.addGestureRecognizer(longPressGestureRecognizer)
	}

}

extension GoalsViewController {

	// MARK: - Navigation
	func presentGoalDetailVC(_ goal: Goal) {
		let goalDetailViewController = GoalDetailViewController()
		goalDetailViewController.viewModel = GoalDetailViewModel(goal: goal)
		navigationController?.pushViewController(goalDetailViewController, animated: true)
	}

	func presentAddGoalVC() {
		let addGoalNameViewController = AddGoalNameViewController()
		addGoalNameViewController.viewModel = AddGoalNameViewModel(mutableGoal: MutableGoal(objectId: UUID().uuidString))
		let navigationController = UINavigationController(rootViewController: addGoalNameViewController)
		present(navigationController, animated: true) {
			self.collectionView.reloadData()
		}
	}

	func didActivateLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
		guard gestureRecognizer.state == .began else { return }

		let point = gestureRecognizer.location(in: collectionView)
		if let indexPath = collectionView.indexPathForItem(at: point), let goal = viewModel.objectAt(indexPath) {
			if goal.progress == goal.frequency {
				viewModel.undo(goal)
			} else {
				viewModel.complete(goal)
			}

			collectionView.reloadData()
		}
	}

}

extension GoalsViewController: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return viewModel.numberOfSections
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard kind == UICollectionElementKindSectionHeader else { return UICollectionReusableView() }

		if let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: CollectionViewHeader.self), for: indexPath) as? CollectionViewHeader {
			if indexPath.section == 1 {
				header.nameLabel.text = "Goals completed"
			} else {
				header.nameLabel.text = "Goals to complete"
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
			print("Current progress \(goal.currentProgress())")
			return cell

		} else if indexPath.section == 0, indexPath.row == viewModel.goalsToComplete.count {
			let cell: AddGoalCollectionViewCell
			if let reusedCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddGoalCollectionViewCell.self), for: indexPath) as? AddGoalCollectionViewCell {
				cell = reusedCell
			} else {
				cell = AddGoalCollectionViewCell()
			}

			cell.newGoalButton.addTarget(self, action: #selector(presentAddGoalVC), for: .touchUpInside)
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

class CollectionViewHeader: UICollectionReusableView {

	let nameLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 14.0)
		label.minimumScaleFactor = 0.6
		label.textColor = .gray
		label.textAlignment = .left
		label.numberOfLines = 4
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)

		addSubview(nameLabel)
		setupConstraints()
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupConstraints() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			nameLabel.widthAnchor.constraint(equalTo: widthAnchor),
			nameLabel.heightAnchor.constraint(equalTo: heightAnchor)
		])
	}

}
