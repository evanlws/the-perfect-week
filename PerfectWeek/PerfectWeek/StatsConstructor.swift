//
//  StatsConstructor.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

final class StatsConstructor {

	// MARK: - Stats to RealmStats
	static func converted(_ stats: Stats) -> RealmStats {
		let realmStats = RealmStats()
		realmStats.objectId = stats.objectId
		realmStats.days = converted(days: stats.days)
		realmStats.perfectWeeks = RealmOptional(stats.perfectWeeks)
		realmStats.currentStreak = RealmOptional(stats.currentStreak)

		return realmStats
	}

	static func converted(days: [Date: Int]) -> List<RealmDay> {
		let daysList = List<RealmDay>()
		days.forEach({ (key: Date, value: Int) in
			let realmDay = RealmDay()
			realmDay.goalsCompleted = RealmOptional(value)
			realmDay.date = key as NSDate
			daysList.append(realmDay)
		})

		return daysList
	}

	// MARK: - RealmStats to Stats
	static func converted(_ realmStats: RealmStats) throws -> Stats {
		guard let perfectWeeks = realmStats.perfectWeeks.value else { throw ConversionError.nilValue(at: "RealmStats.perfectWeeks") }
		guard let currentStreak = realmStats.currentStreak.value else { throw ConversionError.nilValue(at: "RealmStats.currentStreak") }

		let stats = Stats(objectId: realmStats.objectId, days: converted(realmDays: realmStats.days), perfectWeeks: perfectWeeks, currentStreak: currentStreak)
		return stats
	}

	static func converted(realmDays: List<RealmDay>) -> [Date: Int] {
		var days = [Date: Int]()
		realmDays.forEach {
			guard let nsDate = $0.date else { fatalError("Could not cast object. Due date is nil") }
			let date = nsDate as Date
			if let goalsCompleted = $0.goalsCompleted.value {
				days[date] = goalsCompleted
			}
		}

		return days
	}

}
