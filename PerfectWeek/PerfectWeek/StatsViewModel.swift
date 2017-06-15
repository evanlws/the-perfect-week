//
//  StatsViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/11/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class StatsViewModel {

	var graphData = [Double]()
	var graphLabels = [String]()
	var dateRange = ""
	var goalsCompleted = ""
	var results = ""
	var suggestion = ""

	var statsTableViewItems: [(title: String, detail: Int)] = [("Current Streak", 0), ("Completed Today", 0), ("Completed This Week", 0), ("Perfect Weeks", 0), ("Longest Streak", 0)]

	func updateStats() {
		let date = Date()
		let stats = StatsLibrary.shared.stats
		let locale = Locale.autoupdatingCurrent
		let monthDayFormatter = DateFormatter()
		monthDayFormatter.locale = locale
		monthDayFormatter.dateFormat = "M/d"

		graphData = goalsCompletedByDay(stats.days)
		graphLabels = datesGoalsCompleted(stats.days, dateFormatter: monthDayFormatter)

		let lastWeek = lastWeekDateRange(date)
		guard let lastSaturday = Calendar.current.date(byAdding: .day, value: -1, to: lastWeek.upperBound) else {
			guardFailureWarning("Could not get last saturday date")
			return
		}

		statsTableViewItems = zip(statsTableViewItems, tableViewStats(stats: stats, date: date)).map { ($0.0.title, $0.1) }

		let completed = goalsCompleted(in: lastWeek, statsDays: stats.days)
		if completed == 0 {
			return
		}

		dateRange = "\(monthDayFormatter.string(from: lastWeek.lowerBound)) - \(monthDayFormatter.string(from: lastSaturday))"

		let total = totalGoals(in: lastWeek)
		goalsCompleted = "\(completed) out of \(total)"

		if completed == total {
			results = "🎉 Perfect Week! 🎉"
		} else {
			results = "\(total - completed) more goals to complete for a Perfect Week"
		}

		suggestion = "Perfect Week Steak: \(StatsLibrary.shared.stats.perfectWeeks)"
	}

	private func goalsCompletedByDay(_ stats: [Date: Int]) -> [Double] {
		let days = Array(stats.values)
		return days.map { Double($0) }
	}

	private func datesGoalsCompleted(_ stats: [Date: Int], dateFormatter: DateFormatter) -> [String] {
		let dates = Array(stats.keys)
		return dates.map { dateFormatter.string(from: $0) }
	}

	private func lastWeekDateRange(_ date: Date) -> Range<Date> {
		guard let lastWeek = Calendar.current.date(byAdding: .day, value: -7, to: date) else {
			fatalError(guardFailureWarning("Could not get last week's date"))
		}

		return lastWeek.thisWeekSunday() ..< lastWeek.nextWeekSunday()
	}

	private func goalsCompleted(in range: Range<Date>, statsDays: [Date: Int]) -> Int {
		var numberOfGoalsCompleted = 0

		for day in statsDays where range ~= day.key {
			numberOfGoalsCompleted += day.value
		}

		return numberOfGoalsCompleted
	}

	private func totalGoals(in lastWeekDateRange: Range<Date>) -> Int {
		let goals = GoalLibrary.shared.goals.filter { $0.dateAdded < lastWeekDateRange.lowerBound }
		return goals.reduce(0, { $0 + $1.frequency })
	}

	private func tableViewStats(stats: Stats, date: Date) -> [Int] {
		let currentStreak = stats.currentStreak
		let completedToday = stats.days[date.startOfDay()] ?? 0
		let completedThisWeek = goalsCompleted(in: date.thisWeekSunday() ..< date.thisWeekSaturday(), statsDays: stats.days)
		let perfectWeeks = stats.perfectWeeks
		return [currentStreak, completedToday, completedThisWeek, perfectWeeks]
	}

}
