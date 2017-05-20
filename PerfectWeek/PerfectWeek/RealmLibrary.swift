//
//  RealmLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLibrary {

	static let shared = RealmLibrary()

	private let realm: Realm

	var goals: [Goal] {
		return fetchGoals()
	}

	var stats: Stats {
		return fetchStats()
	}

	private init() {
		do {
			try realm = Realm()
		} catch let error {
			fatalError("Error: could not initialize Realm \(error.localizedDescription)")
		}
	}

	func add(_ goal: Goal, completion: (Bool) -> Void) {
		do {
			try realm.write {
				realm.add(GoalConverter.converted(goal))
			}
		} catch {
			print("Could not add goal")
			completion(false)
		}

		completion(true)
	}

	func updateGoal(with values: [String: Any]) {
		do {
			try realm.write {
				realm.create(RealmGoal.self, value: values, update: true)
			}
		} catch let error {
			print("Could not update goal: \(error.localizedDescription)")
		}
	}

	func updateStats(with values: [String: Any]) {
		do {
			try realm.write {
				realm.create(RealmStats.self, value: values, update: true)
			}
		} catch let error {
			print("Could not update stats: \(error.localizedDescription)")
		}
	}

	func deleteGoalWith(_ goalObjectId: String) {
		guard let realmGoal = realm.object(ofType: RealmGoal.self, forPrimaryKey: goalObjectId) else {
			print("Guard failure warning: Could not find object with id")
			return
		}

		do {
			try realm.write {
				realm.delete(realmGoal)
			}
		} catch {
			print("Could not delete goal")
		}
	}

	fileprivate func fetchGoals() -> [Goal] {
		var goals = [Goal]()
		realm.objects(RealmGoal.self).forEach { goals.append(GoalConverter.converted($0)) }
		return goals
	}

	fileprivate func fetchStats() -> Stats {
		if let stats = realm.objects(RealmStats.self).first {
			return StatsConverter.converted(stats)
		}

		print("Could not fetch stats object. Creating a new one.")
		let newStats = Stats(objectId: NSUUID().uuidString)

		do {
			try realm.write {
				realm.add(StatsConverter.converted(newStats))
			}
		} catch let error {
			fatalError("Could not add stats: \(error.localizedDescription)")
		}

		return newStats
	}

}
