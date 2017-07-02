//
//  NotificationLibrary.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 7/1/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

final class NotificationLibrary {

	static let shared = NotificationLibrary()

	private init() {}

	func createAutomaticNotificationComponents(for goal: Goal) -> NotificationComponents {
		let notificationComponents = NotificationComponents(goalId: goal.objectId, frequency: goal.frequency)
		RealmLibrary.shared.add(notificationComponents, completion: { (success) in
			if !success { fatalError() }
		})

		return notificationComponents
	}

}
