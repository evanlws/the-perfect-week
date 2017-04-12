//
//  RealmLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

enum ConversionError: Error {
	case nilValue(at: String)
	case unexpectedFrequencyType(Int)
}

class RealmLibrary {

	static let shared = RealmLibrary()

	private let realm: Realm

	var goals: [Goal] {
		return fetchGoals()
	}

	var stats: Stats {
		return fetchStats()
	}

	init() {
		do {
			try realm = Realm()
		} catch let error {
			fatalError("Error: could not initialize Realm \(error.localizedDescription)")
		}
	}

	func add(_ goal: Goal) {
		do {
			try realm.write {
				try realm.add(GoalConstructor.converted(goal))
			}
		} catch ConversionError.unexpectedFrequencyType(let frequency) {
				debugPrint("Could not convert goal, \(frequency) is not a valid frequency")
		} catch {
			debugPrint("Could not add goal")
		}
	}

	func updateGoal(with values: [String: Any]) {
		var values = values

		if let days = values["days"] as? [Int] {
			values["days"] = GoalConstructor.converted(days)
		}

		do {
			try realm.write {
				realm.create(RealmGoal.self, value: values, update: true)
			}
		} catch let error {
			debugPrint("Could not update goal: \(error.localizedDescription)")
		}
	}

	func updateStats(with values: [String: Any]) {
		do {
			try realm.write {
				realm.create(RealmStats.self, value: values, update: true)
			}
		} catch let error {
			debugPrint("Could not update stats: \(error.localizedDescription)")
		}
	}

	func delete(_ goal: Goal) {
		do {
			try realm.write {
				try realm.delete(GoalConstructor.converted(goal))
			}
		} catch ConversionError.unexpectedFrequencyType(let frequency) {
			debugPrint("Could not convert goal, \(frequency) is not a valid frequency")
		} catch {
			debugPrint("Could not delete goal")
		}
	}

	fileprivate func fetchGoals() -> [Goal] {
		var goals = [Goal]()

		for realmGoal in realm.objects(RealmGoal.self) {
			do {
				try goals.append(GoalConstructor.converted(realmGoal))
			} catch ConversionError.nilValue(let property) {
				debugPrint("Could not convert goal, \(property) is nil")
			} catch ConversionError.unexpectedFrequencyType(let frequency) {
				debugPrint("Could not convert goal, \(frequency) is not a valid frequency")
			} catch {
				fatalError("Unknown error")
			}
		}

		return goals
	}

	fileprivate func fetchStats() -> Stats {
		if let stats = realm.objects(RealmStats.self).first {
			do {
				return try StatsConstructor.converted(stats)
			} catch ConversionError.nilValue(let property) {
				fatalError("Could not convert goal, \(property) is nil")
			} catch {
				fatalError("Unknown error")
			}
		}

		debugPrint("Could not fetch stats object. Creating a new one.")
		let newStats = Stats(objectId: NSUUID().uuidString)

		do {
			try realm.write {
				realm.add(StatsConstructor.converted(newStats))
			}
		} catch let error {
			fatalError("Could not add stats: \(error.localizedDescription)")
		}

		return newStats
	}

}
