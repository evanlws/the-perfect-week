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

	var stats: Stats {
		return RealmLibrary.shared.stats
	}

	private init() {
		if Date() > stats.weekEnd {
			StatsLibrary.shared.updateStats(reason: .newWeek)
			goals.forEach { updateGoal(with: ["objectId": $0.objectId, "progress": 0]) }
		}
	}

	func add(_ newGoal: Goal) {
		RealmLibrary.shared.add(newGoal) { (success) in
			if success {
				NotificationManager.scheduleNotificationFor(newGoal)
			}
		}
	}

	func complete(_ goal: Goal) {
		guard goal.progress != goal.frequency else {
			debugPrint("Guard failure warning: \(goal.name) could not be completed")
			return
		}

		StatsLibrary.shared.updateStats(reason: .goalCompleted)
		updateGoal(with: ["objectId": goal.objectId, "progress": goal.progress + 1, "lastCompleted": Date()])
	}

	func undo(_ goal: Goal) {
		guard goal.progress > 0 else {
			debugPrint("Guard failure warning: Could not undo \(goal.name)")
			return
		}

		StatsLibrary.shared.updateStats(reason: .undoGoal)
		updateGoal(with: ["objectId": goal.objectId, "progress": goal.progress - 1])
	}

	func delete(_ goal: Goal) {
		RealmLibrary.shared.delete(goal)
	}

	func updateGoal(with values: [String: Any]) {
		RealmLibrary.shared.updateGoal(with: values)
	}
}
