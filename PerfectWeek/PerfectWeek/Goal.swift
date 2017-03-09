//
//  Goal.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class Goal: Object {

	dynamic var objectId: String = ""
	dynamic var name: String = ""
	dynamic var isCompleted: Bool = false
	dynamic var weekEnd: Date = Date().nextSunday().addingTimeInterval(1)

	override static func primaryKey() -> String? {
		return "objectId"
	}

}
