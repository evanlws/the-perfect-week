//
//  GoalConstructor.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/19/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class GoalConstructor {

	let realm: Realm

	init() {
		do {
			realm = try Realm()
		} catch let error {
			fatalError("Could not initialize realm object \(error)")
		}
	}

	func fetchGoals() -> [Goal] {
		var goals = [Goal]()

		realm.objects(RealmGoal.self).forEach {
			let frequency: Frequency
			switch $0.frequencyType {
			case 0:
				guard let timesPerWeek = $0.timesPerWeek.value, let weeklyProgress = $0.weeklyProgress.value else { fatalError("Could not cast object") }
				let weekly = Weekly(timesPerWeek: timesPerWeek)
				weekly.weeklyProgress = weeklyProgress
				frequency = weekly
			case 1:
				guard let timesPerDay = $0.timesPerDay.value, let dailyProgress = $0.dailyProgress.value else { fatalError("Could not cast object") }
				let daily = Daily(days: converted($0.days), timesPerDay: timesPerDay)
				daily.dailyProgress = dailyProgress
				frequency = daily
			case 2:
				guard let date = $0.dueDate else { fatalError("Could not cast object. Due date is nil") }
				frequency = Once(dueDate: date as Date)
			default:
				fatalError("Could not cast frequency")
				break
			}

			let goal = Goal(objectId: $0.objectId, name: $0.name, frequency: frequency, isCompleted: $0.isCompleted, weekEnd: $0.weekEnd)
			goals.append(goal)
		}

		return goals
	}

	func updateGoal(with values: [String: Any]) {
		guard let objectId = values["objectId"] as? String else { fatalError("ObjectId is invalid") }

		if let delete = values["DELETE"] as? Bool, delete == true, let objectToDelete = realm.object(ofType: RealmGoal.self, forPrimaryKey: objectId) {
			do {
				try realm.write {
					realm.delete(objectToDelete)
				}
			} catch let error {
				print("Could not delete goal \(error)")
			}

			return
		}

		do {
			try realm.write {
				realm.create(RealmGoal.self, value: values, update: true)
			}
		} catch let error {
			print("Could not update goals \(error.localizedDescription)")
		}
	}

	func add(_ goal: Goal) {
		do {
			try realm.write {
				realm.add(converted(goal))
				print("Successfully added goal \(goal.name)")
			}
		} catch let error {
			fatalError("Error adding goal: \(error)")
		}
	}

	fileprivate func converted(_ goal: Goal) -> RealmGoal {
		let realmGoal = RealmGoal()
		realmGoal.objectId = goal.objectId
		realmGoal.name = goal.name
		realmGoal.isCompleted = goal.isCompleted
		realmGoal.weekEnd = goal.weekEnd
		realmGoal.frequencyType = goal.frequency.type

		switch goal.frequency.type {
		case GoalType.weekly.rawValue:
			if let weekly = goal.frequency as? Weekly {
				realmGoal.timesPerWeek = RealmOptional(weekly.timesPerWeek)
				realmGoal.weeklyProgress = RealmOptional(weekly.weeklyProgress)
			}
		case GoalType.daily.rawValue:
			if let daily = goal.frequency as? Daily {
				realmGoal.timesPerDay = RealmOptional(daily.timesPerDay)
				realmGoal.dailyProgress = RealmOptional(daily.dailyProgress)
				realmGoal.days = converted(daily.days)
			}
		case GoalType.once.rawValue:
			if let once = goal.frequency as? Once {
				realmGoal.dueDate = once.dueDate as NSDate
			}
		default:
			fatalError("Goal type is invalid")
		}

		return realmGoal
	}

	fileprivate func converted(_ days: List<IntObject>) -> [Int] {
		var convertedDays = [Int]()
		days.forEach {
			convertedDays.append($0.value)
		}

		return convertedDays
	}

	fileprivate func converted(_ days: [Int]) -> List<IntObject> {
		let convertedDays = List<IntObject>()
		days.forEach {
			convertedDays.append(IntObject(value: $0))
		}

		return convertedDays
	}

}
