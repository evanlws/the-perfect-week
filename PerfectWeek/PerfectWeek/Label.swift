//
//  Label.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class Label: UILabel {

	static let defaultHeight: CGFloat = Constraints.gridBlock * 4

	enum Style {
		case heading1, heading2, body1, body2, body3, body4
	}

	init(style: Style, color: UIColor = UIColor.black, alignment: NSTextAlignment = NSTextAlignment.natural) {
		super.init(frame: .zero)

		switch style {
		case .heading1:
			self.font = UIFont.boldSystemFont(ofSize: 40)
		case .heading2:
			self.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightSemibold)
		case .body1:
			self.font = UIFont.systemFont(ofSize: 23)
		case .body2:
			self.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightMedium)
		case .body3:
			self.font = UIFont.systemFont(ofSize: 18)
		case .body4:
			self.font = UIFont.systemFont(ofSize: 15)
		}

		self.textColor = color
		self.textAlignment = alignment
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
