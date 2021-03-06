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
		if StatsLibrary.shared.isNewWeek {
			StatsLibrary.shared.updateStats(reason: .newWeek)
			NotificationManager.clearAllNotifications()

			for goal in goals {
				var currentStreak = 0

				if goal.isPerfectGoal() {
					currentStreak = goal.currentStreak + 1
				}

				updateGoal(with: ["objectId": goal.objectId, "progress": 0, "currentStreak": currentStreak])
				clearCompletionDates(goalObjectId: goal.objectId)

				guard let notificationComponents = RealmLibrary.shared.fetchNotificationComponents(with: goal.objectId) else {
					guardFailureWarning("Could not find notification components")
					return
				}

				NotificationManager.scheduleNotification(for: goal, with: notificationComponents)
			}
		}
	}

	func add(_ newGoal: Goal) {
		RealmLibrary.shared.add(newGoal) { (success) in
			if success {
				Answers.logCustomEvent(withName: "Goal Created", customAttributes: nil)
				NotificationLibrary.shared.createAutomaticNotificationComponents(for: newGoal) { notificationComponents in
					NotificationManager.scheduleNotification(for: newGoal, with: notificationComponents)
				}

				print("Successfully created \(newGoal.description)")
			}
		}
	}

	func complete(_ goal: Goal) {
		guard !goal.isPerfectGoal() else {
			print("\(goal.name) was already completed")
			return
		}

		let date = Date()

		updateGoal(with: ["objectId": goal.objectId, "progress": goal.progress + 1, "lastCompleted": date])
		updateCompletionDates(with: date, goalObjectId: goal.objectId)
		NotificationLibrary.shared.adjustNotificationSchedule(for: goal.objectId, completionDates: goal.completionDates)
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

		RealmLibrary.shared.deleteNotificationComponents(with: goalObjectId)
		RealmLibrary.shared.deleteGoal(with: goalObjectId)
	}

	func updateGoal(with values: [String: Any]) {
		RealmLibrary.shared.updateGoal(with: values)
	}

	func updateCompletionDates(with value: Date, goalObjectId: String) {
		RealmLibrary.shared.updateCompletionDates(with: value, goalObjectId: goalObjectId)
	}

	func clearCompletionDates(goalObjectId: String) {
		RealmLibrary.shared.clearCompletionDates(goalObjectId)
	}

	func fetchGoal(with goalId: String) -> Goal? {
		return RealmLibrary.shared.fetchGoal(with: goalId)
	}

}
