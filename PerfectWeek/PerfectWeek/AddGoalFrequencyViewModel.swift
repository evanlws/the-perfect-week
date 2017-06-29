//
//  AddGoalFrequencyViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/14/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class AddGoalFrequencyViewModel {

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

}
