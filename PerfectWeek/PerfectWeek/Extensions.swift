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

	func nextWeekSunday() -> Date {
		let calendar = Calendar(identifier: .gregorian)
		guard let nextSunday = calendar.date(byAdding: .day, value: 7, to: self.thisWeekSunday()) else { fatalError(guardFailureWarning("Could not create Date object")) }
		return calendar.startOfDay(for: nextSunday)
	}

	func thisWeekSunday() -> Date {
		let calendar = Calendar(identifier: .gregorian)
		guard let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { fatalError(guardFailureWarning("Could not create Date object")) }
		return calendar.startOfDay(for: sunday)
	}

	func thisWeekSaturday() -> Date {
		let calendar = Calendar(identifier: .gregorian)
		guard let saturday = calendar.date(bySetting: .weekday, value: 7, of: self) else { fatalError(guardFailureWarning("Could not create Date object")) }
		return calendar.startOfDay(for: saturday)
	}

	func currentWeekday() -> Int {
		if let weekday = Calendar.current.dateComponents([.weekday], from: self).day {
			return weekday
		}

		fatalError(guardFailureWarning("Current weekday is nil"))
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

extension UIColor {

	convenience init(hex: String) {
		let scanner = Scanner(string: hex)
		scanner.scanLocation = 0

		var rgbValue: UInt64 = 0

		scanner.scanHexInt64(&rgbValue)

		let r = (rgbValue & 0xff0000) >> 16
		let g = (rgbValue & 0xff00) >> 8
		let b = rgbValue & 0xff

		self.init(
			red: CGFloat(r) / 0xff,
			green: CGFloat(g) / 0xff,
			blue: CGFloat(b) / 0xff, alpha: 1
		)
	}

}
