//
//  Goal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class Goal: Object {

	dynamic var objectId: String = ""
	dynamic var name: String = ""
	dynamic var isCompleted: Bool = false
	dynamic var weekEnd: Date = Date().nextSunday().addingTimeInterval(1)
	dynamic var frequency: Frequency?

	override static func primaryKey() -> String? {
		return "objectId"
	}

}

class Frequency: Object {

	dynamic var objectId: String = ""
	dynamic var type: Int = 0
	dynamic var timesPerWeek: Int = 1
	dynamic var weeklyProgress: Int = 1

	override static func primaryKey() -> String? {
		return "objectId"
	}

}
