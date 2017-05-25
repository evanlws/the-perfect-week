//
//  Label.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 3/25/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class Label: UILabel {

	static let defaultHeight: CGFloat = 30.0

	enum Style {
		case body, header, header2
	}

	init(style: Style) {
		super.init(frame: .zero)

		switch style {
		case .body:
			self.font = UIFont.systemFont(ofSize: 18)
			self.minimumScaleFactor = 0.6
			self.textColor = .black
			self.textAlignment = .left
		case .header:
			self.font = UIFont.systemFont(ofSize: 22)
			self.minimumScaleFactor = 0.6
			self.textColor = .black
			self.textAlignment = .center
		case .header2:
			self.font = UIFont.systemFont(ofSize: 20)
			self.minimumScaleFactor = 0.6
			self.textColor = .black
			self.textAlignment = .center
		}

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
