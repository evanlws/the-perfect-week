//
//  GoalLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class GoalLibrary {

	static let sharedLibrary = GoalLibrary()

	var goals: [Goal] {
		return RealmLibrary.sharedLibrary.goals
	}

	init() {
		checkGoalsAndUpdate()
	}

	private func checkGoalsAndUpdate() {
		for goal in goals {
			var goalUpdateValues: [String: Any] = ["objectId": goal.objectId]
			var shouldResetFrequency = false

			if goal.weekEnd < Date().nextSunday() {
				goalUpdateValues["weekEnd"] = Date().nextSunday().addingTimeInterval(1)
				goalUpdateValues["isCompleted"] = false
				shouldResetFrequency = true
			}

			switch goal.frequency.type {
			case .weekly:
				guard let weekly = goal.frequency as? Weekly else {
					debugPrint("Guard failure warning: \(goal.name) could not be updated")
					continue
				}
				if goal.isCompleted, weekly.weeklyProgress < weekly.timesPerWeek {
					goalUpdateValues["isCompleted"] = false
				}

				if shouldResetFrequency {
					goalUpdateValues["weeklyProgress"] = 0
				}
			case .daily:
				guard let daily = goal.frequency as? Daily else {
					debugPrint("Guard failure warning: \(goal.name) could not be updated")
					continue
				}

				if goal.isCompleted, daily.dailyProgress < daily.timesPerDay {

					if daily.days.contains(Date().currentWeekday()) {
						goalUpdateValues["isCompleted"] = false
					}
				}

				if shouldResetFrequency {
					goalUpdateValues["dailyProgress"] = 0
				}
			case .once:
				guard let once = goal.frequency as? Once else {
					debugPrint("Guard failure warning: \(goal.name) could not be updated")
					continue
				}

				if (goal.isCompleted && shouldResetFrequency) || (!goal.isCompleted && once.dueDate.startOfDay() < Date().startOfDay()) {
					goalUpdateValues["DELETE"] = true
				}
			}

			RealmLibrary.sharedLibrary.updateGoal(with: goalUpdateValues)
		}
	}

	func add(_ newGoal: Goal) {
		RealmLibrary.sharedLibrary.add(newGoal)
	}

	func complete(_ goal: Goal) {
		if goal.isCompleted == true {
			debugPrint("Guard failure warning: \(goal.name) could not be completed")
			return
		}

		var goalUpdateValues: [String: Any] = ["objectId": goal.objectId]

		switch goal.frequency.type {
		case .weekly:
			guard let weekly = goal.frequency as? Weekly else {
				debugPrint("Guard failure warning: \(goal.name) could not be completed")
				return
			}

			goalUpdateValues["isCompleted"] = true
			goalUpdateValues["weeklyProgress"] = weekly.weeklyProgress + 1
		case .daily:
			guard let daily = goal.frequency as? Daily else {
				debugPrint("Guard failure warning: \(goal.name) could not be completed")
				return
			}

			if daily.timesPerDay == daily.dailyProgress {
				goalUpdateValues["isCompleted"] = true
			}

			goalUpdateValues["dailyProgress"] = daily.timesPerDay + 1
		case .once:
			guard goal.frequency as? Once != nil else {
				debugPrint("Guard failure warning: \(goal.name) could not be completed")
				return
			}

			goalUpdateValues["isCompleted"] = true
		}

		StatsLibrary.sharedLibrary.updateStats(reason: .goalCompleted)
		RealmLibrary.sharedLibrary.updateGoal(with: goalUpdateValues)
	}

	func delete(_ goal: Goal) {
		RealmLibrary.sharedLibrary.delete(goal)
	}

	func updateGoal(with values: [String: Any]) {
		RealmLibrary.sharedLibrary.updateGoal(with: values)
	}
}
