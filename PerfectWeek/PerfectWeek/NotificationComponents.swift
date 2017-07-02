//
//  NotificationComponents.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

typealias TimeOfDay = (hour: Int, minute: Int)

enum DayOfWeek: Int {
	case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

fileprivate enum AutomaticTimeOfDay {
	static let morning: TimeOfDay = (hour: 9, minute: 0)
	static let afternoon: TimeOfDay = (hour: 12, minute: 0)
	static let evening: TimeOfDay = (hour: 18, minute: 0)
}

final class NotificationComponents {

	let objectId: String
	let goalId: String
	let notificationDateComponents: [NotificationDateComponents]

	init(objectId: String, goalId: String, notificationDateComponents: [NotificationDateComponents]) {
		self.objectId = objectId
		self.goalId = goalId
		self.notificationDateComponents = notificationDateComponents
	}

	init(goalId: String, frequency: Int) {
		self.objectId = UUID().uuidString
		self.goalId = goalId
		self.notificationDateComponents = NotificationComponents.defaultNotificationDateComponents(for: frequency)
	}

	var description: String {
		return "\nNotification Components:\n\tObjectID: \(objectId)\n\tGoalId: \(goalId)\n\tNotification Date Components: \(notificationDateComponents)\n"
	}

	private static func defaultNotificationDateComponents(for frequency: Int) -> [NotificationDateComponents] {
		let sunday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .sunday)
		let monday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.morning, dayOfWeek: .monday)
		let wednesday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.afternoon, dayOfWeek: .wednesday)
		let friday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .friday)
		let saturday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.afternoon, dayOfWeek: .saturday)

		switch frequency {
		case 1:
			return [monday, wednesday, friday]
		case 2:
			let tuesday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.morning, dayOfWeek: .tuesday)
			let thursday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .thursday)
			return [tuesday, thursday]
		case 3:
			return [monday, wednesday, friday]
		case 4:
			let tuesday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.afternoon, dayOfWeek: .tuesday)
			let thursday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .thursday)
			return [sunday, tuesday, thursday, friday]
		case 5:
			let tuesday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.morning, dayOfWeek: .tuesday)
			let thursday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .thursday)
			return [monday, tuesday, wednesday, thursday, friday]
		case 6:
			let tuesday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.morning, dayOfWeek: .tuesday)
			let thursday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .thursday)
			return [monday, tuesday, wednesday, thursday, friday, saturday]
		default:
			let tuesday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.morning, dayOfWeek: .tuesday)
			let thursday = NotificationDateComponents(timeOfDay: AutomaticTimeOfDay.evening, dayOfWeek: .thursday)
			return [sunday, monday, tuesday, wednesday, thursday, friday, saturday]
		}
	}

}

final class NotificationDateComponents {

	let timeOfDay: TimeOfDay
	let dayOfWeek: DayOfWeek

	init(timeOfDay: TimeOfDay, dayOfWeek: DayOfWeek) {
		self.timeOfDay = timeOfDay
		self.dayOfWeek = dayOfWeek
	}

	var description: String {
		return "\nNotification Date Components:\n\tTime of Day: \(timeOfDay)\n\tDay of week: \(dayOfWeek)\n"
	}

}
