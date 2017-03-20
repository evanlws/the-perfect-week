//
//  Goal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

enum GoalType: Int {
	case weekly, daily, once
}

class Goal {

	let objectId: String
	var name: String
	var isCompleted: Bool
	var weekEnd: Date
	var frequency: Frequency

	init(objectId: String, name: String, frequency: Frequency, isCompleted: Bool = false, weekEnd: Date = Date().nextSunday().addingTimeInterval(1)) {
		self.objectId = objectId
		self.name = name
		self.isCompleted = isCompleted
		self.weekEnd = weekEnd
		self.frequency = frequency
	}

}

protocol Frequency {

	var type: Int { get set }

}

class Weekly: Frequency {

	var type: Int = 0
	var timesPerWeek: Int
	var weeklyProgress: Int = 0

	init(timesPerWeek: Int = 0) {
		self.timesPerWeek = timesPerWeek
	}

}

class Daily: Frequency {

	var type: Int = 1
	var timesPerDay: Int
	var dailyProgress: Int = 0
	let days: [Int]

	init(days: [Int], timesPerDay: Int = 0) {
		self.days = days
		self.timesPerDay = timesPerDay
	}

}

class Once: Frequency {

	var type: Int = 2
	var dueDate: Date

	init(dueDate: Date = Date().thisSaturday()) {
		self.dueDate = dueDate
	}

}
