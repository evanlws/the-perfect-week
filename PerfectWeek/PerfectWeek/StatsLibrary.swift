//
//  StatsLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class StatsLibrary {

	enum UpdateReason {
		case goalCompleted, undoGoal, newWeek
	}

	static let shared = StatsLibrary()
	private init() {}

	var stats: Stats {
		return RealmLibrary.shared.stats
	}

	var isNewWeek: Bool {
		return Date() > stats.weekEnd
	}

	func updateStats(reason: UpdateReason) {
		var statsUpdateValues: [String: Any] = ["objectId": stats.objectId]

		switch reason {
		case .goalCompleted:
			let goalsCompleted = stats.days[Date().startOfDay()] ?? 0
			var days = stats.days
			days[Date().startOfDay()] = goalsCompleted + 1
			statsUpdateValues["days"] = StatsConverter.converted(days: days)
		case .undoGoal:
			guard let goalsCompleted = stats.days[Date().startOfDay()], goalsCompleted > 0 else { return }
				stats.days[Date().startOfDay()] = goalsCompleted - 1

			statsUpdateValues["days"] = StatsConverter.converted(days: stats.days)
		case .newWeek:
			statsUpdateValues["weekEnd"] = Date().nextWeekSunday().addingTimeInterval(1)
		}

		RealmLibrary.shared.updateStats(with: statsUpdateValues)
	}

}
