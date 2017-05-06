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

		addObservers()
	}

	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(showInformationHeader), name: Notification.Name(rawValue: InformationHeaderObserver.showInformationHeaderNotification), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(hideInformationHeader), name: Notification.Name(rawValue: InformationHeaderObserver.hideInformationHeaderNotification), object: nil)
	}

	@objc func showInformationHeader() {
		if informationWindow.isHidden {
			self.informationWindow.isHidden = false
			UIView.animate(withDuration: 0.1, animations: {
				var frame = self.informationWindow.frame
				frame.origin.y = 0.0
				self.informationWindow.frame = frame
			}, completion: nil)
		}
	}

	@objc func hideInformationHeader() {
		if !informationWindow.isHidden {
			UIView.animate(withDuration: 0.1, animations: {
				var frame = self.informationWindow.frame
				frame.origin.y = -frame.height
				self.informationWindow.frame = frame
			}) { _ in
				self.informationWindow.isHidden = true
			}
		}
	}

	deinit {
		debugPrint("WARNING: Information header is being released")
		NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: InformationHeaderObserver.showInformationHeaderNotification), object: nil)
		NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: InformationHeaderObserver.hideInformationHeaderNotification), object: nil)
	}

}

final class InformationViewController: UIViewController {

	init() {
		super.init(nibName: nil, bundle: nil)
		self.view.backgroundColor = .red
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
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

		let weekdayLabel = UILabel()
		weekdayLabel.font = UIFont.systemFont(ofSize: 36)
		weekdayLabel.textColor = .black
		weekdayLabel.textAlignment = .right
		weekdayLabel.sizeToFit()
		weekdayLabel.adjustsFontSizeToFitWidth = true
		weekdayLabel.text = "Saturday"
		view.addSubview(weekdayLabel)

		let dateLabel = UILabel()
		dateLabel.font = UIFont.systemFont(ofSize: 20)
		dateLabel.textColor = .black
		dateLabel.textAlignment = .right
		dateLabel.sizeToFit()
		dateLabel.adjustsFontSizeToFitWidth = true
		dateLabel.text = "January 28"
		view.addSubview(dateLabel)

		let tipsPagingView = UIView()
		tipsPagingView.backgroundColor = .blue
		view.addSubview(tipsPagingView)

		progressView.translatesAutoresizingMaskIntoConstraints = false
		progressView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + 5.0).isActive = true
		progressView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
		progressView.widthAnchor.constraint(equalTo: progressView.heightAnchor).isActive = true

		multiplierLabel.translatesAutoresizingMaskIntoConstraints = false
		multiplierLabel.leftAnchor.constraint(equalTo: progressView.rightAnchor, constant: 5.0).isActive = true
		multiplierLabel.bottomAnchor.constraint(equalTo: progressView.bottomAnchor).isActive = true

		weekdayLabel.translatesAutoresizingMaskIntoConstraints = false
		weekdayLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: UIApplication.shared.statusBarFrame.size.height + 5.0).isActive = true
		weekdayLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor).isActive = true
		weekdayLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true

		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		dateLabel.topAnchor.constraint(equalTo: weekdayLabel.bottomAnchor, constant: 2.0).isActive = true
		dateLabel.leftAnchor.constraint(equalTo: multiplierLabel.rightAnchor).isActive = true
		dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: progressView.bottomAnchor).isActive = true
		dateLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true

		tipsPagingView.translatesAutoresizingMaskIntoConstraints = false
		tipsPagingView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 5.0).isActive = true
		tipsPagingView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
		tipsPagingView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -5.0).isActive = true
		tipsPagingView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
		tipsPagingView.heightAnchor.constraint(equalToConstant: view.bounds.size.height/3).isActive = true
	}

}
