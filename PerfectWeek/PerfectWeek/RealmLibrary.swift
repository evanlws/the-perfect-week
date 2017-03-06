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
}
