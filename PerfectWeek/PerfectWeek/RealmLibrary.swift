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

	static let sharedLibrary = RealmLibrary()

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
			try realm.add(GoalConstructor.converted(goal))
		} catch ConversionError.unexpectedFrequencyType(let frequency) {
				debugPrint("Could not convert goal, \(frequency) is not a valid frequency")
		} catch {
			debugPrint("Could not add goal")
		}
	}

	func updateGoal(with values: [String: Any]) {
		realm.create(RealmGoal.self, value: values, update: true)
	}

	func updateStats(with values: [String: Any]) {
		realm.create(RealmStats.self, value: values, update: true)
	}

	func delete(_ goal: Goal) {
		do {
			try realm.delete(GoalConstructor.converted(goal))
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
		return Stats(objectId: NSUUID().uuidString)
	}

}
