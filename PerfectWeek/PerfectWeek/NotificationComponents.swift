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

final class NotificationComponents {

	let objectId: String
	let goalId: String
	let notificationDateComponents: [NotificationDateComponents]

	init(objectId: String, goalId: String, notificationDateComponents: [NotificationDateComponents]) {
		self.objectId = objectId
		self.goalId = goalId
		self.notificationDateComponents = notificationDateComponents
	}

	var description: String {
		return "\nNotification Components:\n\tObjectID: \(objectId)\n\tGoalId: \(goalId)\n\tNotification Date Components: \(notificationDateComponents)\n"
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
