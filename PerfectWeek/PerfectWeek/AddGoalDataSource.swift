//
//  AddGoalDataSource.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/14/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

class AddGoalDataSource {

	fileprivate var mutableGoal = MutableGoal(objectId: UUID().uuidString)
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

	func isValid(_ type: GoalType?, timesPerNumber: Int?, onTheseDays: [Int]?, dueDate: Date?) -> Bool {
		guard let type = type else { return false }
		switch type {
		case .weekly:
			guard let timesPerWeek = timesPerNumber else { return false }
			let frequency = Weekly()
			frequency.timesPerWeek = timesPerWeek
			mutableGoal.frequency = frequency
		case .daily:
			guard let timesPerDay = timesPerNumber,
				let onTheseDays = onTheseDays else { return false }
			let frequency = Daily(days: onTheseDays, timesPerDay: timesPerDay)
			mutableGoal.frequency = frequency
		case .once:
			guard let dueDate = dueDate else { return false }
			let frequency = Once()
			frequency.dueDate = dueDate
			mutableGoal.frequency = frequency
		}

		mutableGoal.frequency?.type = type
		return true
	}

	func saveGoal() {
		if let name = mutableGoal.name, let frequency = mutableGoal.frequency {
			let goal = Goal(objectId: mutableGoal.objectId, name: name, frequency: frequency)
			library.add(goal)
		}
	}

}
