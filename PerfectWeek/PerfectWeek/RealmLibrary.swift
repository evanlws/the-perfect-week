//
//  RealmLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLibrary {

	static let sharedLibrary = RealmLibrary()
	let realm: Realm

	var goals: Results<Goal> {
		return fetchGoals()
	}

	init() {
		do {
			realm = try Realm()
		} catch let error {
			fatalError("Error \(error)")
		}
		updateGoals()
	}

	fileprivate func updateGoals() {
		let fetchedGoals = goals
		fetchedGoals.forEach {
			var goalUpdateValues: [String: Any] = ["id": $0.objectId]
			var frequencyUpdateValues: [String: Any] = ["id": $0.frequency!.objectId]

			if $0.weekEnd < Date().nextSunday() {
				goalUpdateValues["weekEnd"] = Date().nextSunday().addingTimeInterval(1)
				goalUpdateValues["isCompleted"] = false
				frequencyUpdateValues["weeklyProgress"] = 0
			}

			if $0.isCompleted, $0.frequency!.weeklyProgress < $0.frequency!.timesPerWeek {
				goalUpdateValues["isCompleted"] = false
			}

			do {
				try realm.write {
					realm.create(Goal.self, value: goalUpdateValues, update: true)
					realm.create(Frequency.self, value: frequencyUpdateValues, update: true)
				}
			} catch let error {
				print("Could not update goals \(error.localizedDescription)")
			}
		}
	}

	fileprivate func fetchGoals() -> Results<Goal> {
		return realm.objects(Goal.self)
	}

	@discardableResult func add(_ newGoal: Goal) -> Bool {
		do {
			try realm.write {
				realm.add(newGoal)
				print("Successfully added goal \(newGoal.name)")
			}
		} catch let error {
			print("Error adding goal: \(error)")
			return false
		}
		return true
	}

	@discardableResult func complete(_ goal: Goal) -> Bool {
		guard let frequency = goal.frequency else { fatalError("Frequency is nil") }
		if goal.isCompleted == true { return false }

		if frequency.weeklyProgress == frequency.timesPerWeek - 1 {
			do {
				try realm.write {
					goal.frequency?.weeklyProgress = frequency.timesPerWeek
					goal.isCompleted = true
					print("Successfully completed goal \(goal.name)")
				}
			} catch let error {
				print("Error completing goal: \(error)")
				return false
			}
		} else {
			do {
				try realm.write {
					goal.isCompleted = true
					goal.frequency?.weeklyProgress = frequency.timesPerWeek + 1
				}
			} catch let error {
				print("Error completing goal: \(error)")
				return false
			}
		}
		return true
	}
}

extension Date {

	func nextSunday() -> Date {
		guard let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: self) else { fatalError() }
		guard let sunday = Calendar.current.date(bySetting: .weekday, value: 1, of: nextWeek) else { fatalError() }
		let cal = Calendar(identifier: .gregorian)
		return cal.startOfDay(for: sunday)
	}

}
