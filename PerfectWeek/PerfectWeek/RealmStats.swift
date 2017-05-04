//
//  RealmStats.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/7/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStats: Object {

	dynamic var objectId: String = ""
	dynamic var perfectWeeks = 0
	dynamic var currentStreak = 0
	dynamic var weekEnd: NSDate = NSDate()
	var days = List<RealmDay>()

	override static func primaryKey() -> String? {
		return "objectId"
	}

}

class RealmDay: Object {

	dynamic var date: NSDate?
	dynamic var goalsCompleted = 0

}
