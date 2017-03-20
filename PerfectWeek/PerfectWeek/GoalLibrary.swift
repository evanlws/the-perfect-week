//
//  GoalLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

class GoalLibrary {

	static let sharedLibrary = GoalLibrary()
	fileprivate let constructor = GoalConstructor()

	var goals: [Goal] {
		return fetchGoals()
	}

	init() {
		updateGoals()
	}

	fileprivate func fetchGoals() -> [Goal] {
		return constructor.fetchGoals()
	}

	fileprivate func updateGoals() {
		let fetchedGoals = goals
		fetchedGoals.forEach {
			var goalUpdateValues: [String: Any] = ["objectId": $0.objectId]
			var shouldResetFrequency = false

			if $0.weekEnd < Date().nextSunday() {
				goalUpdateValues["weekEnd"] = Date().nextSunday().addingTimeInterval(1)
				goalUpdateValues["isCompleted"] = false
				shouldResetFrequency = true
			}

			switch $0.frequency.type {
			case 0:
				guard let weekly = $0.frequency as? Weekly else { fatalError("Frequency could not be casted") }
				if $0.isCompleted, weekly.weeklyProgress < weekly.timesPerWeek {
					goalUpdateValues["isCompleted"] = false
				}

				if shouldResetFrequency {
					goalUpdateValues["weeklyProgress"] = 0
				}
			case 1:
				guard let daily = $0.frequency as? Daily else { fatalError("Frequency could not be casted") }

				if $0.isCompleted, daily.dailyProgress < daily.timesPerDay {

					if daily.days.contains(Date().currentWeekday()) {
						goalUpdateValues["isCompleted"] = false
					}
				}

				if shouldResetFrequency {
					goalUpdateValues["dailyProgress"] = 0
				}
			default:
				guard let once = $0.frequency as? Once else { fatalError("Frequency could not be casted") }

				if ($0.isCompleted && shouldResetFrequency) || (!$0.isCompleted && once.dueDate < Date()) {
					goalUpdateValues["DELETE"] = true
				}
			}

			constructor.updateGoal(with: goalUpdateValues)
		}
	}

	@discardableResult func add(_ newGoal: Goal) {
		constructor.add(newGoal)
	}

	@discardableResult func complete(_ goal: Goal) -> Bool {
		if goal.isCompleted == true { return false }
		var goalUpdateValues: [String: Any] = ["objectId": goal.objectId]

		switch goal.frequency.type {
		case 0:
			guard let weekly = goal.frequency as? Weekly else { fatalError("Frequency could not be casted") }
			goalUpdateValues["isCompleted"] = true
			goalUpdateValues["weeklyProgress"] = weekly.weeklyProgress + 1
		case 1:
			guard let daily = goal.frequency as? Daily else { fatalError("Frequency could not be casted") }
			if daily.timesPerDay == daily.dailyProgress {
				goalUpdateValues["isCompleted"] = true
			}

			goalUpdateValues["dailyProgress"] = daily.timesPerDay + 1
		default:
			guard let _ = goal.frequency as? Once else { fatalError("Frequency could not be casted") }
			goalUpdateValues["isCompleted"] = true
		}

		constructor.updateGoal(with: goalUpdateValues)
		return true
	}
}
