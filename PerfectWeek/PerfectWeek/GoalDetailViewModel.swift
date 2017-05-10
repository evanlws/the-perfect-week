//
//  GoalDetailViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/20/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class GoalDetailViewModel {

	private let library = GoalLibrary.shared

	let goal: Goal

	init(goal: Goal) {
		self.goal = goal
	}

	func completeGoal() {
		library.complete(goal)
	}

	func delete(_ goal: Goal) {
		library.delete(goal)
	}

}
