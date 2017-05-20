//
//  NotificationParser.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/17/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

struct NotificationParser {

	static func generateNotificationIdentifier(_ weekday: Int, hour: Int, minute: Int, type: String, objectId: String) -> String {
		return "{\"weekday\":\"\(weekday)\",\"hour\":\"\(hour)\",\"minute\":\"\(minute)\",\"type\":\"\(type)\",\"objectId\":\"\(objectId)\"}"
	}

	static func objectIdFrom(_ notificationId: String) -> String {
		if let notificationDictionary = NotificationParser.convertToDictionary(text: notificationId) {
			return notificationDictionary["objectId"] as? String ?? ""
		}

		return ""
	}

	static func notificationTypeFrom(_ notificationId: String) -> String {
		if let notificationDictionary = NotificationParser.convertToDictionary(text: notificationId) {
			return notificationDictionary["type"] as? String ?? ""
		}

		return ""
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
