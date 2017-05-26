//
//  GoalConverter.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

struct GoalConverter {

	// MARK: - Goals to RealmGoals
	static func converted(_ goal: Goal) -> RealmGoal {
		let realmGoal = RealmGoal()
		realmGoal.objectId = goal.objectId
		realmGoal.name = goal.name
		realmGoal.frequency = goal.frequency
		realmGoal.notes = goal.notes
		realmGoal.currentStreak = goal.currentStreak
		realmGoal.progress = goal.progress
		realmGoal.lastCompleted = goal.lastCompleted as NSDate?

		realmGoal.extensionName = goal.extensionItem?.name
		realmGoal.extensionType = RealmOptional(goal.extensionItem?.itemType.rawValue)

		return realmGoal
	}

	// MARK: - RealmGoals to Goals
	static func converted(_ realmGoal: RealmGoal) -> Goal {
		let extensionItem = ExtensionItem(name: realmGoal.name, itemType: ExtensionItem.ItemType(rawValue: realmGoal.extensionType.value ?? -1))

		let goal = Goal(objectId: realmGoal.objectId, name: realmGoal.name, frequency: realmGoal.frequency, notes: realmGoal.notes, extensionItem: extensionItem, lastCompleted: realmGoal.lastCompleted as Date?, currentStreak: realmGoal.currentStreak, progress: realmGoal.progress)

		return goal
	}

}
