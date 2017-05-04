//
//  StatsConverter.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

enum ConversionError: Error {
	case nilValue(at: String)
	case unexpectedFrequencyType(Int)
}

final class StatsConverter {

	// MARK: - Stats to RealmStats
	static func converted(_ stats: Stats) -> RealmStats {
		let realmStats = RealmStats()
		realmStats.objectId = stats.objectId
		realmStats.perfectWeeks = stats.perfectWeeks
		realmStats.currentStreak = stats.currentStreak
		realmStats.weekEnd = stats.weekEnd as NSDate
		realmStats.days = converted(days: stats.days)
		return realmStats
	}

	static func converted(days: [Date: Int]) -> List<RealmDay> {
		let daysList = List<RealmDay>()
		days.forEach({ (key: Date, value: Int) in
			let realmDay = RealmDay()
			realmDay.goalsCompleted = value
			realmDay.date = key as NSDate
			daysList.append(realmDay)
		})

		return daysList
	}

	// MARK: - RealmStats to Stats
	static func converted(_ realmStats: RealmStats) -> Stats {
		let stats = Stats(objectId: realmStats.objectId, days: converted(realmDays: realmStats.days), perfectWeeks: realmStats.perfectWeeks, currentStreak: realmStats.currentStreak, weekEnd: realmStats.weekEnd as Date)
		return stats
	}

	static func converted(realmDays: List<RealmDay>) -> [Date: Int] {
		var days = [Date: Int]()
		realmDays.forEach {
			guard let nsDate = $0.date else { fatalError("Could not cast object. Due date is nil") }
			let date = nsDate as Date
			days[date] = $0.goalsCompleted
		}

		return days
	}

}
