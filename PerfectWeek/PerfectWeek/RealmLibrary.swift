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
		goals.forEach {
			if $0.weekEnd < Date().nextSunday() {
				$0.isCompleted = false
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
		do {
			try realm.write {
				goal.isCompleted = true
				print("Successfully completed goal \(goal.name)")
			}
		} catch let error {
			print("Error completing goal: \(error)")
			return false
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
