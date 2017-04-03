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
	private let constructor = GoalConstructor()

	var goals: [Goal] {
		return fetchGoals()
	}

	init() {
		checkGoalsAndUpdate()
	}

	private func fetchGoals() -> [Goal] {
		return constructor.fetchGoals()
	}

	private func checkGoalsAndUpdate() {
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
			case .weekly:
				guard let weekly = $0.frequency as? Weekly else { fatalError("Frequency could not be casted") }
				if $0.isCompleted, weekly.weeklyProgress < weekly.timesPerWeek {
					goalUpdateValues["isCompleted"] = false
				}

				if shouldResetFrequency {
					goalUpdateValues["weeklyProgress"] = 0
				}
			case .daily:
				guard let daily = $0.frequency as? Daily else { fatalError("Frequency could not be casted") }

				if $0.isCompleted, daily.dailyProgress < daily.timesPerDay {

					if daily.days.contains(Date().currentWeekday()) {
						goalUpdateValues["isCompleted"] = false
					}
				}

				if shouldResetFrequency {
					goalUpdateValues["dailyProgress"] = 0
				}
			case .once:
				guard let once = $0.frequency as? Once else { fatalError("Frequency could not be casted") }

				if ($0.isCompleted && shouldResetFrequency) || (!$0.isCompleted && once.dueDate.startOfDay() < Date().startOfDay()) {
					goalUpdateValues["DELETE"] = true
				}
			}

			constructor.updateGoal(with: goalUpdateValues)
		}
	}

	func add(_ newGoal: Goal) {
		constructor.add(newGoal)
	}

	@discardableResult func complete(_ goal: Goal) -> Bool {
		if goal.isCompleted == true { return false }
		var goalUpdateValues: [String: Any] = ["objectId": goal.objectId]

		switch goal.frequency.type {
		case .weekly:
			guard let weekly = goal.frequency as? Weekly else { fatalError("Frequency could not be casted") }
			goalUpdateValues["isCompleted"] = true
			goalUpdateValues["weeklyProgress"] = weekly.weeklyProgress + 1
		case .daily:
			guard let daily = goal.frequency as? Daily else { fatalError("Frequency could not be casted") }
			if daily.timesPerDay == daily.dailyProgress {
				goalUpdateValues["isCompleted"] = true
			}

			goalUpdateValues["dailyProgress"] = daily.timesPerDay + 1
		case .once:
			guard let _ = goal.frequency as? Once else { fatalError("Frequency could not be casted") }
			goalUpdateValues["isCompleted"] = true
		}

		constructor.updateGoal(with: goalUpdateValues)
		return true
	}

	func delete(_ goal: Goal) {
		constructor.delete(goal)
	}

	func updateGoal(with values: [String: Any]) {
		constructor.updateGoal(with: values)
	}
}
