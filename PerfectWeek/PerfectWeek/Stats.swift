//
//  Stats.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class Stats {

	let objectId: String
	var days: [Day]
	var perfectWeeks: Int
	var currentStreak: Int

	init(objectId: String, days: [Day] = [], perfectWeeks: Int = 0, currentStreak: Int = 0) {
		self.objectId = objectId
		self.days = days
		self.perfectWeeks = perfectWeeks
		self.currentStreak = currentStreak
	}

}

final class Day {

	let objectId: String
	let date: Date
	var goalsCompleted: Int

	init(objectId: String, date: Date = Date(), goalsCompleted: Int = 0) {
		self.objectId = objectId
		self.date = date
		self.goalsCompleted = goalsCompleted
	}

}
