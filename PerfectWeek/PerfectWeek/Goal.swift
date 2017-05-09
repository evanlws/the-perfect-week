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
	var lastCompleted: Date?
	var extensionItem: ExtensionItem?

	init(objectId: String,
	     name: String,
	     frequency: Int,
	     extensionItem: ExtensionItem?,
	     lastCompleted: Date?,
	     progress: Int = 0) {
		self.objectId = objectId
		self.name = name
		self.frequency = frequency
		self.progress = progress
		self.lastCompleted = lastCompleted
		self.extensionItem = extensionItem
	}

	convenience init?(_ mutableGoal: MutableGoal) {
		guard let name = mutableGoal.name, let frequency = mutableGoal.frequency else { return nil }
		self.init(objectId: mutableGoal.objectId, name: name, frequency: frequency, extensionItem: mutableGoal.extensionItem, lastCompleted: nil)
	}

	func wasCompletedToday() -> Bool {
		guard let lastCompleted = lastCompleted else { return false }
		return lastCompleted > Date().startOfDay()
	}

	func isPerfectGoal() -> Bool {
		return progress == frequency
	}

	var description: String {
		return "\nGoal:\n\tObjectID: \(objectId)\n\tName: \(name)\n\tLast Completed: \(String(describing: lastCompleted))\n\tFrequency: \(frequency)\n\tProgress: \(progress)\n\tExtension: \(String(describing: extensionItem?.description))\n"
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

	var progress: Int? {
		didSet {
			if progress != oldValue {
				updateValues["progress"] = progress
			}
		}
	}

	var lastCompleted: Date?

	var extensionItem: ExtensionItem?

	init(objectId: String) { // Used when creating a goal
		self.objectId = objectId
		self.updateValues = ["objectId": objectId]
	}

	init(_ goal: Goal) { // Used when updating a goal
		self.objectId = goal.objectId
		self.name = goal.name
		self.frequency = goal.frequency
		self.updateValues = ["objectId": objectId]
	}

}
