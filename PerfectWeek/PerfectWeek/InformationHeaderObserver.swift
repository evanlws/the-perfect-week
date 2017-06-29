//
//  InformationHeaderObserver.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/6/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

struct InformationHeaderObserver {

	static let showInformationHeaderNotification = "ShowInformationHeader"
	static let hideInformationHeaderNotification = "HideInformationHeader"
	static let updateInformationHeaderNotification = "UpdateInformationHeader"

	static func shouldShowInformationHeader() {
		NotificationCenter.default.post(name: Notification.Name(rawValue: InformationHeaderObserver.showInformationHeaderNotification), object: nil)
	}

	static func shouldHideInformationHeader() {
		NotificationCenter.default.post(name: Notification.Name(rawValue: InformationHeaderObserver.hideInformationHeaderNotification), object: nil)
	}

	static func updateInformationHeader() {
		NotificationCenter.default.post(name: Notification.Name(rawValue: InformationHeaderObserver.updateInformationHeaderNotification), object: nil)
	}
}
