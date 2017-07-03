//
//  NotificationComponentsConverter.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

struct NotificationComponentsConverter {

	// MARK: - NotificationComponents to RealmNotificationComponents
	static func converted(_ notificationComponents: NotificationComponents) -> RealmNotificationComponents {
		let realmNotificationComponents = RealmNotificationComponents()
		realmNotificationComponents.objectId = notificationComponents.objectId
		realmNotificationComponents.goalId = notificationComponents.goalId
		realmNotificationComponents.realmNotificationDateComponents = converted(notificationComponents.notificationDateComponents)
		return realmNotificationComponents
	}

	static func converted(_ notificationDateComponentsArray: [NotificationDateComponents]) -> List<RealmNotificationDateComponents> {
		let notificationDateComponentsList = List<RealmNotificationDateComponents>()
		notificationDateComponentsArray.forEach({ (notificationDateComponents) in
			let realmNotificationDateComponents = RealmNotificationDateComponents()
			realmNotificationDateComponents.timeOfDayHour = notificationDateComponents.timeOfDay.hour
			realmNotificationDateComponents.timeOfDayMinute = notificationDateComponents.timeOfDay.minute
			realmNotificationDateComponents.dayOfWeek = notificationDateComponents.dayOfWeek.rawValue
			notificationDateComponentsList.append(realmNotificationDateComponents)
		})

		return notificationDateComponentsList
	}

	// MARK: - RealmNotificationComponents to NotificationComponents
	static func converted(_ realmNotificationComponents: RealmNotificationComponents) -> NotificationComponents {
		let notificationComponents = NotificationComponents(objectId: realmNotificationComponents.objectId, goalId: realmNotificationComponents.goalId, notificationDateComponents: converted(realmNotificationComponents.realmNotificationDateComponents))
		return notificationComponents
	}

	static func converted(_ realmNotificationDateComponentsList: List<RealmNotificationDateComponents>) -> [NotificationDateComponents] {
		var notificationDateComponentsArray = [NotificationDateComponents]()
		realmNotificationDateComponentsList.forEach({ (realmNotificationDateComponents) in
			guard let dayOfWeek = DayOfWeek(rawValue: realmNotificationDateComponents.dayOfWeek) else {
				fatalError(guardFailureWarning("Could not convert day of week"))
			}

			let notificationDateComponents = NotificationDateComponents(timeOfDay: (realmNotificationDateComponents.timeOfDayHour, realmNotificationDateComponents.timeOfDayMinute), dayOfWeek: dayOfWeek)
			notificationDateComponentsArray.append(notificationDateComponents)
		})

		return notificationDateComponentsArray
	}

}
