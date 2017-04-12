//
//  AddGoalTypeViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/14/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class AddGoalTypeViewModel {

	var mutableGoal: MutableGoal
	private let library = GoalLibrary.shared

	init(mutableGoal: MutableGoal) {
		self.mutableGoal = mutableGoal
	}

	func addGoal() {
		if let newGoal = Goal(mutableGoal) {
			library.add(newGoal)
		} else {
			fatalError("Could not add Goal")
		}
	}

	func setMutableGoalItems() {
		guard let frequencyType = mutableGoal.frequencyType else { fatalError("Could not create mutable goal") }
		let frequency: Frequency
		switch frequencyType {
		case .weekly:
			guard let timesPerWeek = mutableGoal.timesPerWeek else { fatalError("Times per week is nil") }
			frequency = Weekly(timesPerWeek: timesPerWeek)
		case .daily:
			guard let timesPerDay = mutableGoal.timesPerDay, let days = mutableGoal.days else { fatalError("Times per day is nil") }
			frequency = Daily(days: days, timesPerDay: timesPerDay)
		case .once:
			guard let date = mutableGoal.dueDate else { fatalError("Due date is nil") }
			frequency = Once(dueDate: date)
		}

		mutableGoal.frequency = frequency
	}

}
