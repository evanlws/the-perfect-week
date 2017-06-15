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

	dynamic var objectId = ""
	dynamic var name = ""
	dynamic var frequency = 0
	dynamic var currentStreak = 0
	dynamic var progress = 0
	dynamic var lastCompleted: NSDate?
	dynamic var dateAdded = NSDate()
	dynamic var notes: String?

	// MARK: - Extension
	var extensionType = RealmOptional<Int>()
	dynamic var extensionName: String?

	override static func primaryKey() -> String? {
		return "objectId"
	}

}
