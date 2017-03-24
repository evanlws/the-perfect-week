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
		self.mutableGoal = MutableGoal(objectId: goal.objectId)
		self.mutableGoal.name = goal.name
		self.mutableGoal.frequency = goal.frequency
	}

	// MARK: - Validation
	func isValid(_ goalName: String?) -> Bool {
		if let goalName = goalName, !goalName.isEmpty, !goalName.isBlank {
			mutableGoal.name = goalName
			return true
		} else {
			return false
		}
	}

	func isValid(_ type: Int?, timesPerNumber: Int?, onTheseDays: [Int]?, dueDate: Date?) -> Bool {
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

	func saveGoal() {
		library.updateGoal(with: mutableGoal.updateValues)
	}

}
