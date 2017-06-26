//
//  RealmNotificationComponents.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class RealmNotificationComponents: Object {

	dynamic var objectId = ""
	dynamic var goalId = ""
	var realmNotificationDateComponents = List<RealmNotificationDateComponents>()

	override static func primaryKey() -> String? {
		return "goalId"
	}

}

class RealmNotificationDateComponents: Object {

	dynamic var timeOfDayHour = 0
	dynamic var timeOfDayMinute = 0
	dynamic var dayOfWeek = 1

}
