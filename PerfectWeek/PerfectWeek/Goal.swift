//
//  Goal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

enum GoalType: Int, CustomStringConvertible {
	case weekly, daily, once

	var description: String {
		switch self {
		case .weekly: return "Weekly"
		case .daily: return "Daily"
		case .once: return "Once"
		}
	}
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

	var type: GoalType { get set }

}

class Weekly: Frequency {

	var type: GoalType = .weekly
	var timesPerWeek: Int
	var weeklyProgress: Int = 0

	init(timesPerWeek: Int = 0) {
		self.timesPerWeek = timesPerWeek
	}

}

class Daily: Frequency {

	var type: GoalType = .daily
	var timesPerDay: Int
	var dailyProgress: Int = 0
	let days: [Int]

	init(days: [Int], timesPerDay: Int = 0) {
		self.days = days
		self.timesPerDay = timesPerDay
	}

}

class Once: Frequency {

	var type: GoalType = .once
	var dueDate: Date

	init(dueDate: Date = Date().thisSaturday()) {
		self.dueDate = dueDate
	}

}

struct MutableGoal {

	var updateValues: [String: Any]
	let objectId: String

	var name: String? {
		didSet {
			if name != oldValue {
				print("Updating name")
				updateValues["name"] = name
			}
		}
	}

	var frequencyType: GoalType? {
		didSet {
			if frequencyType != oldValue {
				updateValues["frequencyType"] = frequencyType
			}
		}
	}

	var timesPerWeek: Int? {
		didSet {
			if timesPerWeek != oldValue {
				updateValues["timesPerWeek"] = timesPerWeek
			}
		}
	}

	var weeklyProgress: Int? {
		didSet {
			if weeklyProgress != oldValue {
				updateValues["weeklyProgress"] = weeklyProgress
			}
		}
	}

	var timesPerDay: Int? {
		didSet {
			if timesPerDay != oldValue {
				updateValues["weeklyProgress"] = timesPerDay
			}
		}
	}

	var dailyProgress: Int? {
		didSet {
			if dailyProgress != oldValue {
				updateValues["dailyProgress"] = dailyProgress
			}
		}
	}

	var days: [Int]? {
		didSet {
			if days ?? [Int]() != oldValue ?? [Int]() {
				updateValues["days"] = days
			}
		}
	}

	var dueDate: Date? {
		didSet {
			if dueDate != oldValue {
				updateValues["dueDate"] = dueDate
			}
		}
	}

	var frequency: Frequency?

	init(objectId: String, name: String? = nil, type: GoalType? = nil) {
		self.objectId = objectId
		self.name = name
		self.frequencyType = type
		self.updateValues = ["objectId": objectId]
	}

}
