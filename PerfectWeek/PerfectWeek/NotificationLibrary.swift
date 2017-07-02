//
//  NotificationLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 7/1/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class NotificationLibrary {

	static let shared = NotificationLibrary()

	private init() {}

	func createAutomaticNotificationComponents(for goal: Goal) -> NotificationComponents {
		let notificationComponents = NotificationComponents(goalId: goal.objectId, frequency: goal.frequency)
		RealmLibrary.shared.add(notificationComponents, completion: { (success) in
			if !success { fatalError() }
		})

		return notificationComponents
	}

	func adjustNotificationSchedule(for goalObjectId: String, completionDates: [Date]) {
		guard let notificationComponents = RealmLibrary.shared.fetchNotificationComponents(with: goalObjectId) else {
			guardFailureWarning("Could not find notification components for that goal id")
			return
		}

		var newNotificationDateComponents = notificationComponents.notificationDateComponents

		for completionDate in completionDates {
			let completionDateComponents = convertNotificationDateComponents(from: completionDate)
			if let closestNotification = closestNotification(to: completionDateComponents, notificationDateComponents: notificationComponents.notificationDateComponents), let indexOfClosestNotification = notificationComponents.notificationDateComponents.index(of: closestNotification) {
				newNotificationDateComponents.remove(at: indexOfClosestNotification)
				newNotificationDateComponents.append(completionDateComponents)
			}
		}

		RealmLibrary.shared.updateNotificationDateComponents(with: newNotificationDateComponents, goalObjectId: goalObjectId)
	}

	// MARK: - Helper functions
	private func closestNotification(to completionDateComponents: NotificationDateComponents, notificationDateComponents: [NotificationDateComponents]) -> NotificationDateComponents? {
		guard !notificationDateComponents.isEmpty else { return nil }
		let completionDay = completionDateComponents.dayOfWeek.rawValue
		let closestDayOfWeek = closestNumInArray(to: completionDay, numbers: notificationDateComponents.map { $0.dayOfWeek.rawValue })

		let notificationDateComponentsMatchingCompletionDay = notificationDateComponents.filter({ $0.dayOfWeek.rawValue == closestDayOfWeek })
		if notificationDateComponentsMatchingCompletionDay.count == 1 {
			return notificationDateComponentsMatchingCompletionDay.first!
		}

		let completionHour = completionDateComponents.timeOfDay.hour
		let closestHour = closestNumInArray(to: completionHour, numbers: notificationDateComponents.map { $0.timeOfDay.hour })
		let notificationDateComponentsMatchingCompletionHour = notificationDateComponentsMatchingCompletionDay.filter({ $0.timeOfDay.hour == closestHour })
		if notificationDateComponentsMatchingCompletionHour.count == 1 {
			return notificationDateComponentsMatchingCompletionHour.first!
		}

		let completionMinute = completionDateComponents.timeOfDay.minute
		let closestMinute = closestNumInArray(to: completionMinute, numbers: notificationDateComponents.map { $0.timeOfDay.minute })
		let notificationDateComponentsMatchingCompletionMinute = notificationDateComponentsMatchingCompletionHour.filter({ $0.timeOfDay.minute == closestMinute })
		if notificationDateComponentsMatchingCompletionMinute.count == 1 {
			return notificationDateComponentsMatchingCompletionMinute.first!
		}

		return nil
	}

	private func closestNumInArray(to initialNumber: Int, numbers: [Int]) -> Int {
		var closest = Int.max
		var closetOffset = Int.max

		for numberItem in numbers {
			let offset = abs(numberItem - initialNumber)
			if offset <= closetOffset {
				closetOffset = offset
				closest = numberItem
			}
		}

		return closest
	}

	private func convertNotificationDateComponents(from date: Date) -> NotificationDateComponents {
		let dateComponents = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
		guard let weekday = dateComponents.weekday,
			let dayOfWeek = DayOfWeek(rawValue: weekday),
			let hour = dateComponents.hour,
			let minute = dateComponents.minute
		else {
			fatalError(guardFailureWarning("Could not convert date to NotificationDateComponents"))
		}

		let timeOfDay = (hour: hour, minute: minute)

		return NotificationDateComponents(timeOfDay: timeOfDay, dayOfWeek: dayOfWeek)
	}

}
