//
//  GoalLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class GoalLibrary {

	static let shared = GoalLibrary()

	var goals: [Goal] {
		return RealmLibrary.shared.goals
	}

	private init() {
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
					RealmLibrary.shared.delete(goal)
					continue
				}
			}

			RealmLibrary.shared.updateGoal(with: goalUpdateValues)
		}
	}

	func add(_ newGoal: Goal) {
		RealmLibrary.shared.add(newGoal)
	}

	func complete(_ goal: Goal) {
		guard goal.isCompleted == false else {
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

		StatsLibrary.shared.updateStats(reason: .goalCompleted)
		RealmLibrary.shared.updateGoal(with: goalUpdateValues)
	}

	func undo(_ goal: Goal) {
		guard goal.isCompleted == true else {
			debugPrint("Guard failure warning: Could not undo \(goal.name)")
			return
		}

		var goalUpdateValues: [String: Any] = ["objectId": goal.objectId, "isCompleted": false]

		switch goal.frequency.type {
		case .weekly:
			guard let weekly = goal.frequency as? Weekly, weekly.weeklyProgress > 0 else {
				debugPrint("Guard failure warning: Could not undo \(goal.name)")
				return
			}

			goalUpdateValues["weeklyProgress"] = weekly.weeklyProgress - 1
		case .daily:
			guard let daily = goal.frequency as? Daily, daily.dailyProgress > 0 else {
				debugPrint("Guard failure warning: Could not undo \(goal.name)")
				return
			}

			goalUpdateValues["dailyProgress"] = daily.timesPerDay - 1
		case .once:
			guard goal.frequency as? Once != nil else {
				debugPrint("Guard failure warning: Could not undo \(goal.name)")
				return
			}
		}

		StatsLibrary.shared.updateStats(reason: .undoGoal)
		RealmLibrary.shared.updateGoal(with: goalUpdateValues)
	}

	func delete(_ goal: Goal) {
		RealmLibrary.shared.delete(goal)
	}

	func updateGoal(with values: [String: Any]) {
		RealmLibrary.shared.updateGoal(with: values)
	}
}
