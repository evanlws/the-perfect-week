//
//  GoalsViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalsViewModel: NSObject {

	enum CellType {
		case goal, addGoal
	}

	let numberOfSections = 2
	private let library = GoalLibrary.shared

	var goalsToComplete: [Goal] {
		return fetchGoals().filter({ !$0.wasCompletedToday() && !$0.isPerfectGoal() })
	}

	var goalsCompleted: [Goal] {
		let goalsToComplete = self.goalsToComplete
		return fetchGoals().filter({ !goalsToComplete.contains($0) })
	}

	var addNewGoalButtonCallback: (() -> Void)?

	private func fetchGoals() -> [Goal] {
		return library.goals
	}

	func complete(_ goal: Goal) {
		library.complete(goal)
	}

}

extension GoalsViewModel: UICollectionViewDataSource {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return numberOfSections
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
		return section == 0 ? goalsToComplete.count + 1 : goalsCompleted.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		switch cellTypeFor(indexPath) {
		case .goal:
			guard let goal = objectAt(indexPath),
				let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GoalCollectionViewCell.self), for: indexPath) as? GoalCollectionViewCell else { break }

			cell.nameLabel.text = goal.name
			cell.progressView.updateProgress(progress: goal.currentProgressPercentage(), animated: false, completion: {})

			return cell
		case .addGoal:
			guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: AddGoalCollectionViewCell.self), for: indexPath) as? AddGoalCollectionViewCell else { break }

			cell.newGoalButton.addTarget(self, action: #selector(didTapNewGoalButton), for: .touchUpInside)
			return cell
		}

		return UICollectionViewCell()
	}

	func cellSize(_ collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
		switch cellTypeFor(indexPath) {
		case .goal:
			return GoalCollectionViewCell.size
		case .addGoal:
			return AddGoalCollectionViewCell.size
		}
	}

	func objectAt(_ indexPath: IndexPath) -> Goal? {
		guard cellTypeFor(indexPath) == .goal else { return nil }

		return indexPath.section == 0 ? goalsToComplete[indexPath.row] : goalsCompleted[indexPath.row]
	}

	@objc func didTapNewGoalButton() {
		addNewGoalButtonCallback?()
	}

	private func cellTypeFor(_ indexPath: IndexPath) -> CellType {
		return indexPath.section == 0 && goalsToComplete.count == indexPath.row ? .addGoal : .goal
	}

}
