//
//  AddGoalNameViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/6/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class AddGoalNameViewModel {

	fileprivate let library = RealmLibrary.sharedLibrary
	fileprivate let goal = Goal()

	init() {
		goal.isCompleted = false
	}

	func validateGoalName(goalName: String?) -> Bool {
		if let goalName = goalName, !goalName.isEmpty, !goalName.isBlank {
			goal.name = goalName
			return true
		} else {
			goal.name = ""
			return false
		}
	}

	func setGoalName() {
		if !library.add(goal) {
			assertionFailure("Goal could not be saved")
		}
	}

}

extension String {
	var isBlank: Bool {
		return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
	}
}
