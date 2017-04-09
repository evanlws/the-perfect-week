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
	var days = List<RealmDay>()
	var perfectWeeks = RealmOptional<Int>()
	var currentStreak = RealmOptional<Int>()

}

class RealmDay: Object {

	dynamic var objectId: String = ""
	dynamic var date: NSDate?
	var goalsCompleted = RealmOptional<Int>()

}