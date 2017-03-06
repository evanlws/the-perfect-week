//
//  GoalsViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class GoalsViewModel {

	fileprivate let library = RealmLibrary.sharedLibrary

	var goals: Results<Goal> {
		return fetchGoals()
	}

	fileprivate func fetchGoals() -> Results<Goal> {
		return library.goals
	}

}
