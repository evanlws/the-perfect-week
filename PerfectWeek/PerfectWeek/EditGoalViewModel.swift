//
//  EditGoalViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/21/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class EditGoalViewModel {

	var mutableGoal: MutableGoal
	private let library = GoalLibrary.shared

	init(goal: Goal) {
		self.mutableGoal = MutableGoal(goal)
	}

	func updateGoal() {
		library.updateGoal(with: mutableGoal.updateValues)
	}

	func deleteGoal() {
		library.deleteGoalWith(mutableGoal.objectId)
	}

}
