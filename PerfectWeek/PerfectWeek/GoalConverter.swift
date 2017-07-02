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
		realmGoal.dateAdded = goal.dateAdded as NSDate
		realmGoal.notes = goal.notes
		realmGoal.currentStreak = goal.currentStreak
		realmGoal.progress = goal.progress
		realmGoal.lastCompleted = goal.lastCompleted as NSDate?
		realmGoal.completionDates = converted(goal.completionDates)

		return realmGoal
	}

	static func converted(_ completionDates: [Date]) -> List<RealmDate> {
		let completionDatesList = List<RealmDate>()
		completionDates.forEach({ date in
			let realmDate = RealmDate()
			realmDate.date = date as NSDate
			completionDatesList.append(realmDate)
		})

		return completionDatesList
	}

	// MARK: - RealmGoals to Goals
	static func converted(_ realmGoal: RealmGoal) -> Goal {
		let goal = Goal(objectId: realmGoal.objectId, name: realmGoal.name, frequency: realmGoal.frequency, dateAdded: realmGoal.dateAdded as Date, notes: realmGoal.notes, lastCompleted: realmGoal.lastCompleted as Date?, currentStreak: realmGoal.currentStreak, progress: realmGoal.progress)

		return goal
	}

	static func converted(_ realmCompletionDates: List<RealmDate>) -> [Date] {
		var completionDates = [Date]()
		realmCompletionDates.forEach({ realmDate in
			let date = realmDate.date as Date
			completionDates.append(date)
		})

		return completionDates
	}

}
