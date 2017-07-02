//
//  Goal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class Goal {

	let objectId: String
	let name: String
	let frequency: Int
	let progress: Int
	let currentStreak: Int
	var dateAdded: Date
	var notes: String?
	var lastCompleted: Date?
	var completionDates: [Date]

	init(objectId: String,
	     name: String,
	     frequency: Int,
	     dateAdded: Date,
	     notes: String?,
	     lastCompleted: Date?,
	     currentStreak: Int = 0,
	     progress: Int = 0,
	     completionDates: [Date] = [Date]()) {
		self.objectId = objectId
		self.name = name
		self.frequency = frequency
		self.dateAdded = dateAdded
		self.notes = notes
		self.currentStreak = currentStreak
		self.progress = progress
		self.lastCompleted = lastCompleted
		self.completionDates = completionDates
	}

	convenience init?(_ mutableGoal: MutableGoal) {
		guard let name = mutableGoal.name, let frequency = mutableGoal.frequency else { return nil }
		let dateAdded = Date()
		self.init(objectId: mutableGoal.objectId, name: name, frequency: frequency, dateAdded: dateAdded, notes: mutableGoal.notes, lastCompleted: nil)
	}

	func wasCompletedToday() -> Bool {
		guard let lastCompleted = lastCompleted else { return false }
		return lastCompleted > Date().startOfDay()
	}

	func isPerfectGoal() -> Bool {
		return progress == frequency
	}

	func currentProgressPercentage() -> CGFloat {
		return CGFloat(progress) / CGFloat(frequency) * 100.0
	}

	var description: String {
		return "\nGoal:\n\tObjectID: \(objectId)\n\tName: \(name)\n\tDate Added: \(String(describing: dateAdded))\n\tLast Completed: \(String(describing: lastCompleted))\n\tFrequency: \(frequency)\n\tNotes: \(String(describing: notes))\n\tProgress: \(progress)\n\tCurrent Streak: \(currentStreak)\n"
	}

}

extension Goal: Equatable {

	static func == (lhs: Goal, rhs: Goal) -> Bool {
		return lhs.objectId == rhs.objectId &&
		lhs.name == rhs.name &&
		lhs.lastCompleted == rhs.lastCompleted
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

	var frequency: Int? {
		didSet {
			if frequency != oldValue {
				updateValues["frequency"] = frequency
			}
		}
	}

	var notes: String? {
		didSet {
			if notes != oldValue {
				updateValues["notes"] = notes
			}
		}
	}

	var progress: Int? {
		didSet {
			if progress != oldValue {
				updateValues["progress"] = progress
			}
		}
	}

	var currentStreak: Int? {
		didSet {
			if currentStreak != oldValue {
				updateValues["currentStreak"] = currentStreak
			}
		}
	}

	var lastCompleted: Date?

	// MARK: - Used when creating a goal
	init(objectId: String) {
		self.objectId = objectId
		self.updateValues = ["objectId": objectId]
	}

	// MARK: - Used when updating a goal
	init(_ goal: Goal) {
		self.objectId = goal.objectId
		self.name = goal.name
		self.frequency = goal.frequency
		self.notes = goal.notes
		self.updateValues = ["objectId": objectId]
	}

}
