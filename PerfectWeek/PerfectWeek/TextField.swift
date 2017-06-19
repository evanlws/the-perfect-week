//
//  TextField.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 6/18/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class TextField: UITextField {

	enum Style {
		case underline
	}

	var path: UIBezierPath?

	init(style: Style) {
		super.init(frame: .zero)
		borderStyle = .none
		contentVerticalAlignment = .bottom
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if path == nil {
			path = UIBezierPath()
			path?.move(to: CGPoint(x: 0, y: frame.size.height))
			path?.addLine(to: CGPoint(x: frame.size.width, y: frame.size.height))
			let underline = CAShapeLayer()
			underline.path = path?.cgPath
			underline.lineWidth = 2.0
			underline.strokeColor = UIColor.black.cgColor
			layer.addSublayer(underline)
		}
	}

}
