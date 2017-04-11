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
		case goalCompleted
	}

	static let sharedLibrary = StatsLibrary()

	var stats: Stats {
		return RealmLibrary.sharedLibrary.stats
	}

	func updateStats(reason: UpdateReason) {
		var statsUpdateValues: [String: Any] = ["objectId": stats.objectId]

		switch reason {
		case .goalCompleted:
			let goalsCompleted = stats.days[Date().startOfDay()]
			stats.days[Date().startOfDay()] = (goalsCompleted ?? 0) + 1
			statsUpdateValues["days"] = StatsConstructor.converted(days: stats.days)
		}

		RealmLibrary.sharedLibrary.updateStats(with: statsUpdateValues)
	}

}
