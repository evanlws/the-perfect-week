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

	let dataSource: AddGoalDataSource

	init() {
		self.dataSource = AddGoalDataSource()
	}

}
