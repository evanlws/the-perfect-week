//
//  EditGoalDataSource.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/22/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

class EditGoalDataSource {

	var mutableGoal: MutableGoal
	fileprivate let library = GoalLibrary.sharedLibrary

	init(goal: Goal) {
		self.mutableGoal = MutableGoal(objectId: goal.objectId, name: goal.name, type: goal.frequency.type)
		self.mutableGoal.frequency = goal.frequency
	}

	// MARK: - Validation
	func isValid(_ type: Int?, goalName: String?, timesPerNumber: Int?, onTheseDays: [Int]?, dueDate: Date?) -> Bool {
		guard let type = type, let rawValue = GoalType(rawValue: type) else { return false }
		switch type {
		case 0:
			guard let timesPerWeek = timesPerNumber else { return false }
			let frequency = Weekly()
			frequency.timesPerWeek = timesPerWeek
			mutableGoal.frequency = frequency
		case 1:
			guard let timesPerDay = timesPerNumber,
				let onTheseDays = onTheseDays else { return false }
			let frequency = Daily(days: onTheseDays, timesPerDay: timesPerDay)
			mutableGoal.frequency = frequency
		case 2:
			guard let dueDate = dueDate else { return false }
			let frequency = Once()
			frequency.dueDate = dueDate
			mutableGoal.frequency = frequency
		default:
			assertionFailure("Type is invalid")
		}

		mutableGoal.frequency?.type = rawValue
		return true
	}

	func updateGoal() {
		library.updateGoal(with: mutableGoal.updateValues)
	}

}
