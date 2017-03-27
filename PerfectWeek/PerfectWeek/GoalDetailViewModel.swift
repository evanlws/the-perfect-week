//
//  GoalDetailViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/20/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class GoalDetailViewModel {

	private let library = GoalLibrary.sharedLibrary

	let goal: Goal

	init(goal: Goal) {
		self.goal = goal
	}

	func delete(_ goal: Goal) {
		library.delete(goal)
	}

}
