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
	var days: [Date: Int]
	var perfectWeeks: Int
	var currentStreak: Int
	var weekEnd: Date

	init(objectId: String, days: [Date: Int] = [:], perfectWeeks: Int = 0, currentStreak: Int = 0, weekEnd: Date = Date().nextWeekSunday().addingTimeInterval(1)) {
		self.objectId = objectId
		self.days = days
		self.perfectWeeks = perfectWeeks
		self.currentStreak = currentStreak
		self.weekEnd = weekEnd
	}

	var description: String {
		return "\nGoal:\n\tObjectID: \(objectId)\n\tPerfect Weeks: \(perfectWeeks)\n\tCurrent Streak: \(currentStreak)\n\tWeekEnd: \(weekEnd)\n"
	}

}
