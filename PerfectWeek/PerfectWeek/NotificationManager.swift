//
//  NotificationManager.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/6/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UserNotifications

struct NotificationManager {

	enum TimeOfDay: Int {
		case morning = 9
		case afternoon = 12
		case evening = 6
	}

	static func requestNotificationsPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, _) in
			if !accepted {
				debugPrint("Notification access denied.")
			}
		}
	}

	static func scheduleNotificationFor(_ goal: Goal) {
		let content = UNMutableNotificationContent()
		content.title = "Don't forget"
		content.body = goal.name
		content.sound = UNNotificationSound.default()

//		let triggerWeekly = Calendar.current.dateComponents([.weekday,hour,.minute,.second,], from: date)
//		let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: true)

	}

	static func weeklyDateComponentsFor(_ frequency: Int, date: Date) -> [DateComponents] {
		var dateComponents = [DateComponents]()

		switch frequency {
		case 1:
			let thisSaturday = date.thisSaturday()
			if let monday = Calendar.current.date(byAdding: .weekday, value: 2, to: thisSaturday) {
				let weekdayComponents = Calendar.current.dateComponents([.weekday, .hour], from: dateOf(monday, .morning))
				dateComponents.append(weekdayComponents)
			}

			if let wednesday = Calendar.current.date(byAdding: .weekday, value: 4, to: thisSaturday) {
				let weekdayComponents = Calendar.current.dateComponents([.weekday, .hour], from: dateOf(wednesday, .afternoon))
				dateComponents.append(weekdayComponents)
			}

			if let friday = Calendar.current.date(byAdding: .weekday, value: 6, to: thisSaturday) {
				let weekdayComponents = Calendar.current.dateComponents([.weekday, .hour], from: dateOf(friday, .evening))
				dateComponents.append(weekdayComponents)
			}

			return dateComponents

		default:
			return dateComponents
		}
	}

	static func dateOf(_ date: Date, _ timeOfDay: TimeOfDay) -> Date {
		guard let time = Calendar.current.date(byAdding: .hour, value: timeOfDay.rawValue, to: date) else { fatalError("Could not create date component") }
		return time
	}
}
