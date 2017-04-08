//
//  StatsConstructor.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/8/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

final class StatsConstructor {

	let realm: Realm

	init() {
		do {
			realm = try Realm()
		} catch let error {
			fatalError("Could not initialize realm object \(error)")
		}
	}

}
