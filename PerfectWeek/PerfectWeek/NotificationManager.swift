//
//  NotificationManager.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/6/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UserNotifications
import UserNotificationsUI

class NotificationManager: NSObject {

	enum TimeOfDay: Int {
		case morning = 9
		case afternoon = 12
		case evening = 18
	}

	enum DayOfWeek: Int {
		case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
	}

	static func requestNotificationsPermission() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {(accepted, _) in
			if !accepted {
				print("Notification access denied.")
			}
		}
	}

	static func clearAllNotifications() {
		UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
		UNUserNotificationCenter.current().removeAllDeliveredNotifications()
	}

	static func scheduleNotificationFor(_ goal: Goal) {
		let notificationCenter = UNUserNotificationCenter.current()

		let content = UNMutableNotificationContent()
		content.title = LocalizedStrings.dontForget
		content.body = goal.name
		content.sound = .default()

		for dateComponents in weeklyDateComponentsFor(goal.frequency, date: Date()) {
			let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
			guard let hour = dateComponents.hour, let minute = dateComponents.minute, let weekday = dateComponents.weekday else {
				print("Guard failure warning: One or more components in dateComponents are nil")
				continue
			}

			let identifier = NotificationParser.generateNotificationIdentifier(weekday, hour: hour, minute: minute, type: "DEFAULT", objectId: goal.objectId)
			let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
			notificationCenter.add(request) { (error) in
				if let error = error {
					print("Error scheduling a notification \(error)")
				} else {
					print("Scheduling a notification for \(goal.name) on weekday \(weekday) at: \(hour):\(minute)")
				}
			}
		}
	}

	static func weeklyDateComponentsFor(_ frequency: Int, date: Date) -> [DateComponents] {
		var dateComponents = [DateComponents]()
		let thisSaturday = date.thisSaturday()

		let sunday = weekdayComponent(.sunday, timeOfDay: .evening, date: thisSaturday)
		let monday = weekdayComponent(.monday, timeOfDay: .morning, date: thisSaturday)
		let wednesday = weekdayComponent(.wednesday, timeOfDay: .afternoon, date: thisSaturday)
		let friday = weekdayComponent(.friday, timeOfDay: .evening, date: thisSaturday)
		let saturday = weekdayComponent(.saturday, timeOfDay: .afternoon, date: thisSaturday)

		switch frequency {
		case 1:
			dateComponents.append(contentsOf: [monday, wednesday, friday])
		case 2:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: .morning, date: thisSaturday)
			let thursday = weekdayComponent(.thursday, timeOfDay: .evening, date: thisSaturday)
			dateComponents.append(contentsOf: [tuesday, thursday])
		case 3:
			dateComponents.append(contentsOf: [monday, wednesday, friday])
		case 4:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: .afternoon, date: thisSaturday)
			let thursday = weekdayComponent(.thursday, timeOfDay: .evening, date: thisSaturday)
			dateComponents.append(contentsOf: [sunday, tuesday, thursday, friday])
		case 5:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: .morning, date: thisSaturday)
			let thursday = weekdayComponent(.thursday, timeOfDay: .evening, date: thisSaturday)
			dateComponents.append(contentsOf: [monday, tuesday, wednesday, thursday, friday])
		case 6:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: .morning, date: thisSaturday)
			let thursday = weekdayComponent(.thursday, timeOfDay: .evening, date: thisSaturday)
			dateComponents.append(contentsOf: [monday, tuesday, wednesday, thursday, friday, saturday])
		default:
			let tuesday = weekdayComponent(.tuesday, timeOfDay: .morning, date: thisSaturday)
			let thursday = weekdayComponent(.thursday, timeOfDay: .evening, date: thisSaturday)
			dateComponents.append(contentsOf: [sunday, monday, tuesday, wednesday, thursday, friday, saturday])
		}

		return dateComponents
	}

	fileprivate static func weekdayComponent(_ dayOfWeek: DayOfWeek, timeOfDay: TimeOfDay, date: Date) -> DateComponents {
		guard let weekday = Calendar.current.date(byAdding: .weekday, value: dayOfWeek.rawValue, to: date) else { fatalError("Tried to create a date that didn't exist") }
		return Calendar.current.dateComponents([.weekday, .hour, .minute], from: dateOf(weekday, timeOfDay))
	}

	private static func dateOf(_ date: Date, _ timeOfDay: TimeOfDay) -> Date {
		guard let hoursEdit = Calendar.current.date(byAdding: .hour, value: timeOfDay.rawValue, to: date),
			let time = Calendar.current.date(byAdding: .minute, value: 0, to: hoursEdit) else { fatalError("Could not create date component") }
		return time
	}
}

// MARK: - Completing Goal Notifications
extension NotificationManager: UNNotificationContentExtension {

	func didReceive(_ notification: UNNotification) {
		if NotificationParser.notificationTypeFrom(notification.request.identifier) == "TEMP" {
			let requests = NotificationManager.unarchivedRequests(data: notification.request.content.userInfo["requests"] as? Data)
			for request in requests {
				UNUserNotificationCenter.current().add(request) { (error) in
					if let error = error {
						print("Error scheduling a notification \(error)")
					} else {
						print("ReScheduling a notification for \(request.identifier)")
					}
				}
			}
		}
	}

	static func updateNotificationForGoal(_ goalObjectId: String) {
		NotificationManager.cancelFutureNotificationsForGoal(goalObjectId) { (requests) in
			guard let firstRequest = earliestRequest(requests: requests) else {
				print("Guard failure warning: There was no earliest request")
				return
			}

			scheduleTempRequest(firstRequest, requests: requests)
		}
	}

	private static func cancelFutureNotificationsForGoal(_ goalObjectId: String, completion: @escaping ([UNNotificationRequest]) -> Void) {
		var requests = [UNNotificationRequest]()
		UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
			for request in notificationRequests {
				if NotificationParser.objectIdFrom(request.identifier) == goalObjectId {
					requests.append(request)
					UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
				}
			}

			completion(requests)
		}
	}

	private static func scheduleTempRequest(_ request: UNNotificationRequest, requests: [UNNotificationRequest]) {
		let notificationCenter = UNUserNotificationCenter.current()

		let content = UNMutableNotificationContent()
		content.title = request.content.title
		content.body = request.content.body
		content.sound = .default()
		content.userInfo["requests"] = archived(requests)

		let identifier = request.identifier.replacingOccurrences(of: "\"type\":\"DEFAULT\"", with: "\"type\":\"TEMP\"")

		guard let requestTrigger = request.trigger as? UNCalendarNotificationTrigger else { fatalError("Could not get request trigger") }
		let tempRequestTrigger = UNCalendarNotificationTrigger(dateMatching: requestTrigger.dateComponents, repeats: false)

		let tempRequest = UNNotificationRequest(identifier: identifier, content: content, trigger: tempRequestTrigger)
		notificationCenter.add(tempRequest) { (error) in
			if let error = error {
				print("Error scheduling a notification \(error)")
			} else {
				print("Scheduling a TEMP notification for \(tempRequest.identifier)")
			}
		}
	}

	private static func archived(_ requests: [UNNotificationRequest]) -> Data {
		return NSKeyedArchiver.archivedData(withRootObject: requests)
	}

	private static func unarchivedRequests(data: Data?) -> [UNNotificationRequest] {
		guard let data = data, let requests = NSKeyedUnarchiver.unarchiveObject(with: data) as? [UNNotificationRequest] else { return [UNNotificationRequest]() }
		return requests
	}

	private static func earliestRequest(requests: [UNNotificationRequest]) -> UNNotificationRequest? {
		var nextRequest: UNNotificationRequest?

		for currentRequest in requests {
			if nextRequest == nil {
				nextRequest = currentRequest
				continue
			}

			guard let currentRequestTrigger = currentRequest.trigger as? UNCalendarNotificationTrigger,
				let nextRequestTrigger = nextRequest?.trigger as? UNCalendarNotificationTrigger else { continue }

			if currentRequestTrigger.dateComponents < nextRequestTrigger.dateComponents {
				nextRequest = currentRequest
			}
		}

		return nextRequest
	}
}
