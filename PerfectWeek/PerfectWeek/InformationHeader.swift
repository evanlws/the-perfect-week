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

		setupViews()
	}

	// MARK: - Setup
	private func setupViews() {
		let progressView = UIView()
		progressView.backgroundColor = .yellow
		view.addSubview(progressView)

		let multiplierLabel = UILabel()
		multiplierLabel.text = "x2"
		multiplierLabel.font = UIFont.systemFont(ofSize: 23)
		view.addSubview(multiplierLabel)

		let dayOfWeekLabel = UILabel()
		dayOfWeekLabel.font = UIFont.systemFont(ofSize: 36)
		dayOfWeekLabel.textColor = .black
		dayOfWeekLabel.textAlignment = .right
		dayOfWeekLabel.text = "Saturday"
		view.addSubview(dayOfWeekLabel)

		let dateLabel = UILabel()
		dateLabel.font = UIFont.systemFont(ofSize: 20)
		dateLabel.textColor = .black
		dateLabel.textAlignment = .right
		dateLabel.text = "January 28"
		view.addSubview(dateLabel)

		let tipsPagingView = UIView()
		tipsPagingView.backgroundColor = .blue
		view.addSubview(tipsPagingView)

		progressView.translatesAutoresizingMaskIntoConstraints = false
		progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + 8.0).isActive = true
		progressView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
		progressView.widthAnchor.constraint(equalToConstant: 75).isActive =  true
		progressView.heightAnchor.constraint(equalTo: progressView.widthAnchor).isActive = true

		multiplierLabel.translatesAutoresizingMaskIntoConstraints = false
		multiplierLabel.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: 5.0).isActive = true
		multiplierLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true

		dayOfWeekLabel.translatesAutoresizingMaskIntoConstraints = false
		dayOfWeekLabel.topAnchor.constraint(equalTo: progressView.topAnchor).isActive = true
		dayOfWeekLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor).isActive = true
		dayOfWeekLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true

		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.topAnchor.constraint(equalTo: dayOfWeekLabel.bottomAnchor, constant: 5.0).isActive = true
		dateLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor).isActive = true
		dateLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true

		tipsPagingView.translatesAutoresizingMaskIntoConstraints = false
		tipsPagingView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5.0).isActive = true
		tipsPagingView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
		tipsPagingView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -5.0).isActive = true
		tipsPagingView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}
