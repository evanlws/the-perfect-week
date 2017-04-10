//
//  GoalConstructor.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

final class GoalConstructor {

	// MARK: - Goals to RealmGoals
	static func converted(_ goal: Goal) throws -> RealmGoal {
		let realmGoal = RealmGoal()
		realmGoal.objectId = goal.objectId
		realmGoal.name = goal.name
		realmGoal.isCompleted = goal.isCompleted
		realmGoal.weekEnd = goal.weekEnd
		realmGoal.frequencyType = goal.frequency.type.rawValue

		switch goal.frequency.type {
		case .weekly:
			guard let weekly = goal.frequency as? Weekly else { throw ConversionError.unexpectedFrequencyType(goal.frequency.type.rawValue) }
			realmGoal.timesPerWeek = RealmOptional(weekly.timesPerWeek)
			realmGoal.weeklyProgress = RealmOptional(weekly.weeklyProgress)
		case .daily:
			guard let daily = goal.frequency as? Daily else { throw ConversionError.unexpectedFrequencyType(goal.frequency.type.rawValue) }
			realmGoal.timesPerDay = RealmOptional(daily.timesPerDay)
			realmGoal.dailyProgress = RealmOptional(daily.dailyProgress)
			realmGoal.days = converted(daily.days)

		case .once:
			guard let once = goal.frequency as? Once else { throw ConversionError.unexpectedFrequencyType(goal.frequency.type.rawValue) }
			realmGoal.dueDate = once.dueDate as NSDate
		}

		return realmGoal
	}

	static func converted(_ days: [Int]) -> List<IntObject> {
		let convertedDays = List<IntObject>()
		days.forEach {
			let intObject = IntObject()
			intObject.value = $0
			convertedDays.append(intObject)
		}

		return convertedDays
	}

	// MARK: - RealmGoals to Goals
	static func converted(_ realmGoal: RealmGoal) throws -> Goal {
		let frequency: Frequency
		switch realmGoal.frequencyType {
		case 0:
			guard let timesPerWeek = realmGoal.timesPerWeek.value else { throw ConversionError.nilValue(at: "RealmGoal.timesPerWeek") }
			guard let weeklyProgress = realmGoal.weeklyProgress.value else { throw ConversionError.nilValue(at: "RealmGoal.weeklyProgress") }
			let weekly = Weekly(timesPerWeek: timesPerWeek)
			weekly.weeklyProgress = weeklyProgress
			frequency = weekly
		case 1:
			guard let timesPerDay = realmGoal.timesPerDay.value else { throw ConversionError.nilValue(at: "RealmGoal.timesPerDay") }
			guard let dailyProgress = realmGoal.dailyProgress.value else { throw ConversionError.nilValue(at: "RealmGoal.dailyProgress") }
			let daily = Daily(days: converted(realmGoal.days), timesPerDay: timesPerDay)
			daily.dailyProgress = dailyProgress
			frequency = daily
		case 2:
			guard let date = realmGoal.dueDate else { throw ConversionError.nilValue(at: "RealmGoal.dueDate") }
			frequency = Once(dueDate: date as Date)
		default:
			throw ConversionError.unexpectedFrequencyType(realmGoal.frequencyType)
		}

		let goal = Goal(objectId: realmGoal.objectId, name: realmGoal.name, frequency: frequency, isCompleted: realmGoal.isCompleted, weekEnd: realmGoal.weekEnd)
		return goal
	}

	static func converted(_ days: List<IntObject>) -> [Int] {
		var convertedDays = [Int]()
		days.forEach {
			convertedDays.append($0.value)
		}

		return convertedDays
	}
}
