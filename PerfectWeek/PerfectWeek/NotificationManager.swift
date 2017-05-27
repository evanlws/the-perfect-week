//
//  NotificationManager.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/6/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UserNotifications

class NotificationManager: NSObject {

	enum TimeOfDay {
		static let morning = (hour: 9, minute: 0)
		static let afternoon = (hour: 12, minute: 0)
		static let evening = (hour: 18, minute: 0)
	}

	enum DayOfWeek: Int {
		case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
	}

	static func requestNotificationsPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, _) in
			if !accepted {
				print("Notification access denied.")
			}
		}
	}

	static func clearAllNotifications() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
	}

	static func scheduleNotification(for goal: Goal) {
		let date = Date()

		let content = UNMutableNotificationContent()
		content.title = LocalizedStrings.dontForget
		content.body = goal.name
		content.sound = .default()

		for dateComponents in weeklyDateComponents(for: goal.frequency, date: date) {
			scheduleNotification(with: content, dateComponents: dateComponents, goal: goal)
			//let nextWeekDateComponents = nextWeek(dateComponents: dateComponents, date: date)
			//scheduleNotification(with: content, dateComponents: nextWeekDateComponents, goal: goal)
		}
	}

	private static func nextWeek(dateComponents: DateComponents, date: Date) -> DateComponents {
		guard let date = Calendar.current.date(from: dateComponents),
			let newDate = Calendar.current.date(byAdding: .day, value: 7, to: date) else { fatalError("Could not create date from components") }
		return Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: newDate)
	}

	private static func scheduleNotification(with content: UNMutableNotificationContent, dateComponents: DateComponents, goal: Goal) {
		let notificationCenter = UNUserNotificationCenter.current()
		let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		guard let date = Calendar.current.date(from: dateComponents) else {
			print("Guard failure warning: One or more components in dateComponents are nil")
			return
		}

		let identifier = NotificationParser.generateNotificationIdentifier(date: date, type: "DEFAULT", objectId: goal.objectId)
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
		notificationCenter.add(request) { (error) in
			if let error = error {
				print("Error scheduling a notification \(error)")
			} else {
				print("Scheduling a notification for \(goal.name) for \(identifier) ::::: \(Date())")
			}
		}
	}

	static func weeklyDateComponents(for frequency: Int, date: Date) -> [DateComponents] {
		var dateComponents = [DateComponents]()

		let sunday = weekdayComponent(.sunday, timeOfDay: TimeOfDay.evening, date: date)
		let monday = weekdayComponent(.monday, timeOfDay: TimeOfDay.morning, date: date)
		let wednesday = weekdayComponent(.wednesday, timeOfDay: TimeOfDay.afternoon, date: date)
		let friday = weekdayComponent(.friday, timeOfDay: TimeOfDay.evening, date: date)
		let saturday = weekdayComponent(.saturday, timeOfDay: TimeOfDay.afternoon, date: date)

		switch frequency {
		case 1:
			dateComponents.append(contentsOf: [monday, wednesday, friday])
		case 2:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: TimeOfDay.morning, date: date)
			let thursday = weekdayComponent(.thursday, timeOfDay: TimeOfDay.evening, date: date)
			dateComponents.append(contentsOf: [tuesday, thursday])
		case 3:
			dateComponents.append(contentsOf: [monday, wednesday, friday])
		case 4:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: TimeOfDay.afternoon, date: date)
			let thursday = weekdayComponent(.thursday, timeOfDay: TimeOfDay.evening, date: date)
			dateComponents.append(contentsOf: [sunday, tuesday, thursday, friday])
		case 5:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: TimeOfDay.morning, date: date)
			let thursday = weekdayComponent(.thursday, timeOfDay: TimeOfDay.evening, date: date)
			dateComponents.append(contentsOf: [monday, tuesday, wednesday, thursday, friday])
		case 6:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: TimeOfDay.morning, date: date)
			let thursday = weekdayComponent(.thursday, timeOfDay: TimeOfDay.evening, date: date)
			dateComponents.append(contentsOf: [monday, tuesday, wednesday, thursday, friday, saturday])
		default:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: TimeOfDay.morning, date: date)
			let thursday = weekdayComponent(.thursday, timeOfDay: TimeOfDay.evening, date: date)
			dateComponents.append(contentsOf: [sunday, monday, tuesday, wednesday, thursday, friday, saturday])
		}

		return dateComponents
	}

	fileprivate static func weekdayComponent(_ dayOfWeek: DayOfWeek, timeOfDay: (hour: Int, minute: Int), date: Date) -> DateComponents {
		guard let weekdayAddedDate = Calendar.current.date(bySetting: .weekday, value: dayOfWeek.rawValue, of: date),
		let hourAddedDate = Calendar.current.date(bySetting: .hour, value: timeOfDay.hour, of: weekdayAddedDate),
		let minuteAddedDate = Calendar.current.date(bySetting: .minute, value: timeOfDay.minute, of: hourAddedDate) else { fatalError("Tried to create a date that didn't exist") }
		return Calendar.current.dateComponents([.year, .month, .day, .weekday, .hour, .minute], from: minuteAddedDate)
	}

}

// MARK: - Updating Notifications
extension NotificationManager {

	static func cancelNotificationThisWeek(for goal: Goal) {
		UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
			for request in requests {
				guard NotificationParser.getObjectId(from: request.identifier) == goal.objectId,
				let trigger = request.trigger as? UNCalendarNotificationTrigger,
				let triggerDate = trigger.nextTriggerDate() else { continue }

				if triggerDate < Date().nextSunday() {
					UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
				}
			}
		}
	}

}
