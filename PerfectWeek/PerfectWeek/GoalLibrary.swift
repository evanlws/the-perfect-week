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
import Crashlytics

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
				Answers.logCustomEvent(withName: "Goal Created", customAttributes: nil)
				print("Successfully created \(newGoal.description)")
				NotificationManager.scheduleNotification(for: newGoal)
			}
		}
	}

	func complete(_ goal: Goal) {
		guard !goal.isPerfectGoal() else {
			print("\(goal.name) was already completed")
			return
		}

		updateGoal(with: ["objectId": goal.objectId, "progress": goal.progress + 1, "lastCompleted": Date()])
		Answers.logCustomEvent(withName: "Goal Completed", customAttributes: nil)
		StatsLibrary.shared.updateStats(reason: .goalCompleted)
		InformationHeaderObserver.updateInformationHeader()
	}

	func deleteGoalWith(_ goalObjectId: String) {
		Answers.logCustomEvent(withName: "Goal Deleted", customAttributes: nil)

		UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
			let requestIdentifiers = requests.flatMap({ NotificationParser.getObjectId(from: $0.identifier) }).filter({ $0 == goalObjectId })
			UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: requestIdentifiers)
		}

		RealmLibrary.shared.deleteGoalWith(goalObjectId)
	}

	func updateGoal(with values: [String: Any]) {
		RealmLibrary.shared.updateGoal(with: values)
	}

	func fetchGoal(with goalId: String) -> Goal? {
		return RealmLibrary.shared.fetchGoal(with: goalId)
	}

}
