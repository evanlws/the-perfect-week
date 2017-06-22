//
//  NotificationDelegate.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/22/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UserNotifications

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {

	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
		completionHandler([])
	}

	func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
		switch response.actionIdentifier {
		case UNNotificationDismissActionIdentifier:
			print("Dismiss action")
		case UNNotificationDefaultActionIdentifier:
			print("Default")
		case NotificationManager.NotificationActionIdentifier.completeAction.rawValue:
			let goalId = NotificationParser.getObjectId(from: response.notification.request.identifier)
			if let goal = GoalLibrary.shared.fetchGoal(with: goalId) {
				GoalLibrary.shared.complete(goal)
			}

			print("Complete")
		case NotificationManager.NotificationActionIdentifier.remindMeInAnHourAction.rawValue:
			print("Remind me in an hour")
		default:
			print("Unknown action")
		}

		completionHandler()
	}

}
