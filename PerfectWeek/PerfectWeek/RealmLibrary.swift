//
//  RealmLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/4/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation
import RealmSwift

class RealmLibrary {

	static let sharedLibrary = RealmLibrary()
	let realm: Realm

	var goals: Results<Goal> {
		return fetchGoals()
	}

	init?() {
		do {
			realm = try Realm()
		} catch let error {
			fatalError("ERROR \(error)")
		}
	}

	fileprivate func fetchGoals() -> Results<Goal> {
		return realm.objects(Goal.self)
	}

}
