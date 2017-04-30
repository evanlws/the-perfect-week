//
//  InformationHeader.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 4/29/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class InformationHeader {

	static var windowSize: CGSize = .zero
	private let informationWindow: UIWindow

	init() {
		guard let keyWindow = UIApplication.shared.keyWindow else { fatalError("Must have a key window") }

		informationWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: keyWindow.bounds.size.width, height: keyWindow.bounds.size.height / 3.8))
		InformationHeader.windowSize = CGSize(width: informationWindow.bounds.width, height: informationWindow.bounds.height)
		informationWindow.windowLevel = UIWindowLevelNormal
		informationWindow.isHidden = false
		let informationViewController = InformationViewController()
		informationWindow.rootViewController = informationViewController
	}

	deinit {
		debugPrint("WARNING: Information header is being released")
	}

}

final class InformationViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)
		self.view.backgroundColor = .red
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		setupStackView()
	}

	// MARK: - Setup
	private func setupStackView() {

	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
