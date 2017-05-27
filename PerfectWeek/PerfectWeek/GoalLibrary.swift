//
//  GoalLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import UIKit
import NotificationCenter
import UserNotifications
import UserNotificationsUI

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
			NotificationManager.clearAllNotifications()
			for goal in goals {
				var currentStreak = 0

				if goal.isPerfectGoal() {
					currentStreak = goal.currentStreak + 1
				}

				updateGoal(with: ["objectId": goal.objectId, "progress": 0, "currentStreak": currentStreak])
				NotificationManager.scheduleNotification(for: goal)
			}
		}
	}

	func add(_ newGoal: Goal) {
		RealmLibrary.shared.add(newGoal) { (success) in
			if success {
				print("Successfully created \(newGoal.description)")
				NotificationManager.scheduleNotification(for: newGoal)
			}
		}
	}

	func complete(_ goal: Goal) {
		guard !goal.isPerfectGoal(), !goal.wasCompletedToday() else {
			print("Guard failure warning: \(goal.name) was already completed")
			return
		}

		updateGoal(with: ["objectId": goal.objectId, "progress": goal.progress + 1, "lastCompleted": Date()])
		StatsLibrary.shared.updateStats(reason: .goalCompleted)
		InformationHeaderObserver.updateInformationHeader()
	}

	func deleteGoalWith(_ goalObjectId: String) {
		RealmLibrary.shared.deleteGoalWith(goalObjectId)
	}

	func updateGoal(with values: [String: Any]) {
		RealmLibrary.shared.updateGoal(with: values)
	}
}
