//
//  AddGoalDataSource.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/14/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

struct MutableGoal {
	var name: String?
	var objectId: String?
	var frequency: Frequency?

}

class AddGoalDataSource {

	fileprivate var mutableGoal = MutableGoal()
	fileprivate let library = GoalLibrary.sharedLibrary

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
		guard let type = type else { return false }
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

		mutableGoal.frequency?.type = type
		return true
	}

	func saveGoal() {
		mutableGoal.objectId = UUID().uuidString
		if let name = mutableGoal.name, let objectId = mutableGoal.objectId, let frequency = mutableGoal.frequency {
			let goal = Goal(objectId: objectId, name: name, frequency: frequency)
			library.add(goal)
		}
	}

}
