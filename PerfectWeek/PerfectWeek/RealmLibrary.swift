//
//  RealmLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RealmLibrary {

	static let shared = RealmLibrary()

	fileprivate let realm: Realm

	private init() {
		do {
			try realm = Realm()
		} catch let error {
			fatalError("Error: could not initialize Realm \(error.localizedDescription)")
		}
	}

}

// MARK: Goals
extension RealmLibrary {

	var goals: [Goal] {
		return fetchGoals()
	}

	func fetchGoal(with goalId: String) -> Goal? {
		if let realmGoal = realm.object(ofType: RealmGoal.self, forPrimaryKey: goalId) {
			let goal = GoalConverter.converted(realmGoal)
			return goal
		}

		return nil
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

	func deleteGoal(with goalObjectId: String) {
		guard let realmGoal = realm.object(ofType: RealmGoal.self, forPrimaryKey: goalObjectId) else {
			guardFailureWarning("Could not find object with id")
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
		return realm.objects(RealmGoal.self).flatMap { GoalConverter.converted($0) }
	}

}

// MARK: Stats
extension RealmLibrary {

	var stats: Stats {
		return fetchStats()
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

// MARK: NotificationComponents
extension RealmLibrary {

	var notificationComponents: [NotificationComponents] {
		return fetchNotificationComponents()
	}

	func add(_ notificationComponents: NotificationComponents, completion: (Bool) -> Void) {
		do {
			try realm.write {
				realm.add(NotificationComponentsConverter.converted(notificationComponents))
			}
		} catch {
			print("Could not add notification components")
			completion(false)
		}

		completion(true)
	}

	func fetchNotificationComponents(with goalId: String) -> NotificationComponents? {
		if let realmNotificationComponents = realm.object(ofType: RealmNotificationComponents.self, forPrimaryKey: goalId) {
			let notificationComponents = NotificationComponentsConverter.converted(realmNotificationComponents)
			return notificationComponents
		}

		return nil
	}

	func deleteNotificationComponents(with goalObjectId: String) {
		guard let realmNotificationComponents = realm.object(ofType: RealmNotificationComponents.self, forPrimaryKey: goalObjectId) else {
			guardFailureWarning("Could not find object with id")
			return
		}

		do {
			try realm.write {
				realm.delete(realmNotificationComponents)
			}
		} catch {
			print("Could not delete notification components")
		}
	}

	fileprivate func fetchNotificationComponents() -> [NotificationComponents] {
		return realm.objects(RealmNotificationComponents.self).flatMap { NotificationComponentsConverter.converted($0) }
	}

}
