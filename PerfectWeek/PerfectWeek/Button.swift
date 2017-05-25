//
//  Button.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/24/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

enum ButtonType {
	case basicBox
}

struct Button {

	static func initialize(type: ButtonType) -> UIButton {
		let button = UIButton(type: .custom)
		button.backgroundColor = ColorLibrary.UIPalette.primary
		button.titleLabel?.textColor = .white
		return button
	}

}
