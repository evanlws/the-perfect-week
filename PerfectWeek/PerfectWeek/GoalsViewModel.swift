//
//  GoalsViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class GoalsViewModel {

	private let library = GoalLibrary.sharedLibrary

	var goals: [Goal] {
		return fetchGoals()
	}

	private func fetchGoals() -> [Goal] {
		return library.goals
	}

	func complete(_ goal: Goal) {
		library.complete(goal)
	}

}
