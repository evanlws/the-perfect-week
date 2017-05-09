//
//  GoalsViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class GoalsViewModel: NSObject {

	let numberOfSections = 2
	private let library = GoalLibrary.shared

	var goalsCompletedToday: [Goal] {
		return fetchGoals().filter({ $0.wasCompletedToday() })
	}

	var goalsToComplete: [Goal] {
		return fetchGoals().filter({ !$0.wasCompletedToday() })
	}

	private func fetchGoals() -> [Goal] {
		return library.goals
	}

	func complete(_ goal: Goal) {
		library.complete(goal)
	}

	func undo(_ goal: Goal) {
		library.undo(goal)
	}

	func objectAt(_ indexPath: IndexPath) -> Goal? {
		guard goalsToComplete.count > indexPath.row || goalsCompletedToday.count > indexPath.row else { return nil }
		return indexPath.section == 0 ? goalsToComplete[indexPath.row] : goalsCompletedToday[indexPath.row]
	}

}
