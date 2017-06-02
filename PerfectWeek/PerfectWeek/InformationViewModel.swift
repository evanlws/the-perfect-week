//
//  InformationViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/2/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

struct InformationViewModel {

	var streak: String {
		return "x\(StatsLibrary.shared.stats.currentStreak)"
	}

	var weekday: String {
		return currentDate().weekday
	}

	var date: String {
		return currentDate().date
	}

	func currentWeekProgress() -> Int {
		let goals = GoalLibrary.shared.goals
		guard goals.count > 0 else { return 0 }
		let totalProgress = goals.reduce(0, { $0 + $1.progress })
		let totalFrequency = goals.reduce(0, { $0 + $1.frequency })
		return Int(Float(totalProgress) / Float(totalFrequency) * 100.0)
	}

	private func currentDate() -> (date: String, weekday: String) {
		let currentDate = Date()
		let locale = Locale.autoupdatingCurrent
		let weekdayDateFormat = DateFormatter.dateFormat(fromTemplate: "EEEE", options: 0, locale: locale)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = weekdayDateFormat
		let weekday = dateFormatter.string(from: currentDate)

		let dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMMM", options: 0, locale: locale)
		dateFormatter.dateFormat = dateFormat
		let date = dateFormatter.string(from: currentDate)

		return (date, weekday)
	}

}
