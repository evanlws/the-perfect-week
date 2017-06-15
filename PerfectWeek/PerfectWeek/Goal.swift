//
//  Goal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class Goal {

	let objectId: String
	let name: String
	let frequency: Int
	let progress: Int
	let currentStreak: Int
	var dateAdded: Date
	var notes: String?
	var lastCompleted: Date?
	var extensionItem: ExtensionItem?

	init(objectId: String,
	     name: String,
	     frequency: Int,
	     dateAdded: Date,
	     notes: String?,
	     extensionItem: ExtensionItem?,
	     lastCompleted: Date?,
	     currentStreak: Int = 0,
	     progress: Int = 0) {
		self.objectId = objectId
		self.name = name
		self.frequency = frequency
		self.dateAdded = dateAdded
		self.notes = notes
		self.currentStreak = currentStreak
		self.progress = progress
		self.lastCompleted = lastCompleted
		self.extensionItem = extensionItem
	}

	convenience init?(_ mutableGoal: MutableGoal) {
		guard let name = mutableGoal.name, let frequency = mutableGoal.frequency else { return nil }
		let dateAdded = Date()
		self.init(objectId: mutableGoal.objectId, name: name, frequency: frequency, dateAdded: dateAdded, notes: mutableGoal.notes, extensionItem: mutableGoal.extensionItem, lastCompleted: nil)
	}

	func wasCompletedToday() -> Bool {
		guard let lastCompleted = lastCompleted else { return false }
		return lastCompleted > Date().startOfDay()
	}

	func isPerfectGoal() -> Bool {
		return progress == frequency
	}

	func currentProgressPercentage() -> Int {
		return Int(Float(progress) / Float(frequency) * 100.0)
	}

	var description: String {
		return "\nGoal:\n\tObjectID: \(objectId)\n\tName: \(name)\n\tDate Added: \(String(describing: dateAdded))\n\tLast Completed: \(String(describing: lastCompleted))\n\tFrequency: \(frequency)\n\tNotes: \(String(describing: notes))\n\tProgress: \(progress)\n\tCurrent Streak: \(currentStreak)\n\tExtension: \(String(describing: extensionItem?.description))\n"
	}

}

final class ExtensionItem {

	enum ItemType: Int, CustomStringConvertible {
		case steps, walkingAndRunning, focusSession

		var description: String {
			switch self {
			case .steps:
				return "Steps"
			case .walkingAndRunning:
				return "Walking + Running"
			case .focusSession:
				return "Focus Session"
			}
		}
	}

	let name: String
	let itemType: ItemType

	init?(name: String?, itemType: ItemType?) {
		guard let name = name, let itemType = itemType else { return nil }

		self.name = name
		self.itemType = itemType
	}

	var description: String {
		return "\nExtension:\n\tName: \(name)\n\tItemType: \(itemType.description)\n"
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

	var extensionItem: ExtensionItem?

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
