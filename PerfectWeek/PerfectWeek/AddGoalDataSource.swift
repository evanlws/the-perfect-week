//
//  AddGoalDataSource.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/14/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class AddGoalDataSource {

	fileprivate let goal = Goal()
	fileprivate let library = RealmLibrary.sharedLibrary

	init() {
		goal.isCompleted = false
		goal.objectId = UUID().uuidString
	}

	func setGoalName(goalName: String?) -> Bool {
		if let goalName = goalName, !goalName.isEmpty, !goalName.isBlank {
			goal.name = goalName
			return true
		} else {
			goal.name = ""
			return false
		}
	}

	func setGoalTimesPerWeek(timesPerWeek: Int) {
		goal.timesPerWeek = timesPerWeek
	}

	func saveGoal() {
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
