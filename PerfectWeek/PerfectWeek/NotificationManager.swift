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

	enum NotificationActionIdentifier: String {
		case completeAction = "CompleteAction"
		case remindMeInAnHourAction = "RemindMeInAnHour"
		case reminderCategory = "PerfectWeekReminderCategory"
	}

	enum NotificationIdentifierType: String {
		case automatic = "AUTOMATIC"
		case rescheduled = "RESCHEDULED"
		case custom = "CUSTOM"
	}

	static func requestNotificationsPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (accepted, _) in
			if !accepted {
				print("Notification access denied.")
			}
		}
	}

	static func setupNotificationActions() {
		let completeAction = UNNotificationAction(identifier: NotificationActionIdentifier.completeAction.rawValue, title: LocalizedStrings.completeGoal, options: [])
		let remindMeOneHourAction = UNNotificationAction(identifier: NotificationActionIdentifier.remindMeInAnHourAction.rawValue, title: LocalizedStrings.remindMeInOneHour, options: [])
		let category = UNNotificationCategory(identifier: NotificationActionIdentifier.reminderCategory.rawValue, actions: [completeAction, remindMeOneHourAction], intentIdentifiers: [], options: [])
		UNUserNotificationCenter.current().setNotificationCategories([category])
	}

	static func clearAllNotifications() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
	}

	static func scheduleNotification(for goal: Goal) {
		let date = Date()

		let content = UNMutableNotificationContent()
		content.categoryIdentifier = NotificationActionIdentifier.reminderCategory.rawValue
		content.title = LocalizedStrings.dontForget
		content.body = goal.name
		content.sound = .default()

		for dateComponents in weeklyDateComponents(for: goal.frequency, date: date) {
			scheduleAutomaticNotification(with: content, dateComponents: dateComponents, goal: goal, date: date)
		}
	}

	static func refireNotification(delay: TimeInterval, request: UNNotificationRequest) {
		let newDate = Date().addingTimeInterval(delay)
		let objectId = NotificationParser.getObjectId(from: request.identifier)
		let newNotificationId = NotificationParser.generateNotificationIdentifier(date: newDate, type: NotificationIdentifierType.rescheduled.rawValue, objectId: objectId)
		let hourDelayTrigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
		let request = UNNotificationRequest(identifier: newNotificationId, content: request.content, trigger: hourDelayTrigger)

		UNUserNotificationCenter.current().add(request) { (error) in
			print("Scheduling notification", newNotificationId)
			if let error = error {
				print("Error scheduling a notification \(error)")
			}
		}
	}

	private static func scheduleAutomaticNotification(with content: UNMutableNotificationContent, dateComponents: DateComponents, goal: Goal, date: Date) {

		let calendarNotificationTrigger = trigger(with: dateComponents, date: date)
		guard let triggerDate = calendarNotificationTrigger.nextTriggerDate() else {
			fatalError(guardFailureWarning("Trigger date is still nil"))
		}

		let identifier = NotificationParser.generateNotificationIdentifier(date: triggerDate, type: NotificationIdentifierType.automatic.rawValue, objectId: goal.objectId)
		let request = UNNotificationRequest(identifier: identifier, content: content, trigger: calendarNotificationTrigger)
		UNUserNotificationCenter.current().add(request) { (error) in
			print("Scheduling notification", identifier)
			if let error = error {
				print("Error scheduling a notification \(error)")
			}
		}
	}

	private static func trigger(with dateComponents: DateComponents, date: Date) -> UNCalendarNotificationTrigger {
		var trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
		while trigger.nextTriggerDate() == nil {
			trigger = UNCalendarNotificationTrigger(dateMatching: nextWeek(dateComponents: dateComponents, date: date), repeats: false)
		}

		return trigger
	}

	private static func nextWeek(dateComponents: DateComponents, date: Date) -> DateComponents {
		guard let date = Calendar.current.date(from: dateComponents),
			let newDate = Calendar.current.date(byAdding: .day, value: 7, to: date) else { fatalError("Could not create date from components") }
		return requiredDateComponents(from: newDate)
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
			let dateAddedDate = Calendar.current.date(bySettingHour: timeOfDay.hour, minute: timeOfDay.minute, second: 0, of: weekdayAddedDate) else { fatalError(guardFailureWarning("Tried to create a date that didn't exist")) }
		return requiredDateComponents(from: dateAddedDate)
	}

	private static func requiredDateComponents(from date: Date) -> DateComponents {
		return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
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

				if triggerDate < Date().nextWeekSunday() {
					UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
				}
			}
		}
	}

}
