//
//  RealmGoal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class RealmGoal: Object {

	dynamic var objectId: String = ""
	dynamic var name: String = ""
	dynamic var isCompleted: Bool = false
	dynamic var weekEnd: Date = Date().nextSunday().addingTimeInterval(1)

	// MARK: - Frequency
	dynamic var frequencyType: Int = 0

	// MARK: - Weekly
	var timesPerWeek = RealmOptional<Int>()
	var weeklyProgress = RealmOptional<Int>()

	// MARK: - Daily
	var timesPerDay = RealmOptional<Int>()
	var dailyProgress = RealmOptional<Int>()
	var days = List<IntObject>()

	// MARK: - Once
	dynamic var dueDate: NSDate?

	override static func primaryKey() -> String? {
		return "objectId"
	}

}

// Hack because for some strange reason realm does not support arrays
class IntObject: Object {
	dynamic var value = 0
}
