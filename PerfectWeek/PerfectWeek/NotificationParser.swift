//
//  NotificationParser.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/17/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

struct NotificationParser {

	static func generateNotificationIdentifier(date: Date, type: String, objectId: String) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm"
		let dateString = formatter.string(from: date)
		return "{\"date\":\"\(dateString)\",\"type\":\"\(type)\",\"objectId\":\"\(objectId)\"}"
	}

	static func getObjectId(from notificationId: String) -> String {
		if let notificationDictionary = NotificationParser.convertToDictionary(text: notificationId) {
			return notificationDictionary["objectId"] as? String ?? ""
		}

		return ""
	}

	static func getNotificationType(from notificationId: String) -> String {
		if let notificationDictionary = NotificationParser.convertToDictionary(text: notificationId) {
			return notificationDictionary["type"] as? String ?? ""
		}

		return ""
	}

	static func getNotificationDate(from notificationId: String) -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd HH:mm"

		if let notificationDictionary = NotificationParser.convertToDictionary(text: notificationId), let dateString = notificationDictionary["date"] as? String {
			return formatter.date(from: dateString)
		}

		return nil
	}

	static func convertToDictionary(text: String) -> [String: Any]? {
		if let data = text.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				print(error.localizedDescription)
			}
		}

		return nil
	}

}
