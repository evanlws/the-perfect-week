//
//  Extensions.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/18/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

extension String {

	var isBlank: Bool {
		return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}

	func capitalizingFirstLetter() -> String {
		let first = String(characters.prefix(1)).capitalized
		let other = String(characters.dropFirst())
		return first + other
	}

}

extension Date {

	func nextSunday() -> Date {
		guard let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: self),
			let sunday = Calendar.current.date(bySetting: .weekday, value: 1, of: nextWeek) else { fatalError("Could not create Date object") }

		let cal = Calendar(identifier: .gregorian)
		return cal.startOfDay(for: sunday)
	}

	func thisSaturday() -> Date {
		guard let saturday = Calendar.current.date(bySetting: .weekday, value: 7, of: self) else { fatalError("Could not create Date object") }

		let cal = Calendar(identifier: .gregorian)
		return cal.startOfDay(for: saturday)
	}

	func currentWeekday() -> Int {
		if let weekday = Calendar.current.dateComponents([.weekday], from: self).day {
			return weekday
		}
		fatalError("Current weekday is nil")
	}

}
