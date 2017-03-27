//
//  Label.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class Label: UILabel {

	enum Style {
		case body
	}

	init(style: Style) {
		super.init(frame: .zero)

		switch style {
		case .body:
			self.font = UIFont.systemFont(ofSize: 18)
			self.minimumScaleFactor = 0.6
			self.textColor = .black
			self.textAlignment = .left
		}

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
