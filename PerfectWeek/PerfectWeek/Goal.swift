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

final class Goal {

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

	convenience init?(_ mutableGoal: MutableGoal) {
		guard let name = mutableGoal.name, let frequency = mutableGoal.frequency else { return nil }
		self.init(objectId: mutableGoal.objectId, name: name, frequency: frequency)
	}

	var description: String {
		return "\nGoal:\n\tObjectID: \(objectId)\n\tName: \(name)\n\tCompleted: \(isCompleted ? "Yes" : "No")\n\tWeekend Date: \(weekEnd)\n\tFrequencyType: \(frequency.type.rawValue)\n"
	}

}

protocol Frequency {

	var type: GoalType { get set }

}

final class Weekly: Frequency {

	var type: GoalType = .weekly
	var timesPerWeek: Int
	var weeklyProgress: Int = 0

	init(timesPerWeek: Int = 0) {
		self.timesPerWeek = timesPerWeek
	}

}

final class Daily: Frequency {

	var type: GoalType = .daily
	var timesPerDay: Int
	var dailyProgress: Int = 0
	let days: [Int]

	init(days: [Int], timesPerDay: Int = 0) {
		self.days = days
		self.timesPerDay = timesPerDay
	}

}

final class Once: Frequency {

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
				updateValues["name"] = name
			}
		}
	}

	var frequencyType: GoalType? {
		didSet {
			if frequencyType != oldValue {
				resetFrequency()
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
				updateValues["timesPerDay"] = timesPerDay
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

	init(_ goal: Goal) {
		self.objectId = goal.objectId
		self.name = goal.name
		self.frequencyType = goal.frequency.type
		self.frequency = goal.frequency
		self.updateValues = ["objectId": objectId]
	}

	mutating func resetFrequency() {
		guard let goalName = name, let goalFrequencyType = frequencyType else { fatalError("No goal name or frequency. What are you updating?") }
		self.updateValues = ["objectId": objectId, "name": goalName, "frequencyType": goalFrequencyType.rawValue]
		weeklyProgress = 0
		dailyProgress = 0
	}

}
