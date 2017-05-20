//
//  Extensions.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/18/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

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

	func startOfDay() -> Date {
		let calendar = Calendar(identifier: .gregorian)
		return calendar.startOfDay(for: self)
	}

}

extension NSRange {

	func range(for str: String) -> Range<String.Index>? {
		guard location != NSNotFound else { return nil }

		guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
		guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
		guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
		guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }

		return fromIndex ..< toIndex
	}

}

extension UIButton {

	convenience init(style: UIButtonType) {
		self.init(type: style)

		self.setTitleColor(.white, for: .normal)
		self.backgroundColor = .purple
	}

}

extension DateComponents: Comparable {

	public static func < (lhs: DateComponents, rhs: DateComponents) -> Bool {
		if (lhs.year != nil && rhs.year != nil) ||
			(lhs.month != nil && rhs.month != nil) ||
			(lhs.day != nil && rhs.day != nil),
			let lhsDate = lhs.date,
			let rhsDate = rhs.date {
			return lhsDate < rhsDate
		}

		if let lhsWeekday = lhs.weekday {
			if let rhsWeekday = rhs.weekday {
				if lhsWeekday == rhsWeekday, let lhsDate = lhs.date, let rhsDate = rhs.date {
					return lhsDate < rhsDate
				} else {
					return lhsWeekday < rhsWeekday
				}
			} else {
				return true
			}
		}

		return false
	}

}
