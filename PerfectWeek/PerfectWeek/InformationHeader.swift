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
	private let informationViewController: InformationViewController

	init() {
		guard let keyWindow = UIApplication.shared.keyWindow else { fatalError(guardFailureWarning("Must have a key window")) }

		informationWindow = UIWindow(frame: CGRect(x: 0, y: 0, width: keyWindow.bounds.size.width, height: 176))
		InformationHeader.windowSize = CGSize(width: informationWindow.bounds.width, height: informationWindow.bounds.height)
		informationWindow.windowLevel = UIWindowLevelNormal
		informationWindow.isHidden = false
		informationViewController = InformationViewController()
		informationWindow.rootViewController = informationViewController

		addObservers()
	}

	private func addObservers() {
		NotificationCenter.default.addObserver(self, selector: #selector(showInformationHeader), name: Notification.Name(rawValue: InformationHeaderObserver.showInformationHeaderNotification), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(hideInformationHeader), name: Notification.Name(rawValue: InformationHeaderObserver.hideInformationHeaderNotification), object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateInformationHeader), name: Notification.Name(rawValue: InformationHeaderObserver.updateInformationHeaderNotification), object: nil)
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

	@objc func updateInformationHeader() {
		informationViewController.updateInformation()
	}

	deinit {
		print("WARNING: Information header is being released")
		NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: InformationHeaderObserver.showInformationHeaderNotification), object: nil)
		NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: InformationHeaderObserver.hideInformationHeaderNotification), object: nil)
	}

}
