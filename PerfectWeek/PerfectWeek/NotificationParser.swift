//
//  NotificationParser.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/17/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

struct NotificationParser {

	static func objectIdFrom(_ notificationID: String) -> String {
		let notificationArray = notificationID.components(separatedBy: "$")
		return notificationArray.last ?? ""
	}

}
