//
//  AppDelegate.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/18/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var informationHeader: InformationHeader?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white

		let goalsViewController = GoalsViewController(viewModel: GoalsViewModel())
		let navigationController = UINavigationController(rootViewController: goalsViewController)
		navigationController.tabBarItem = UITabBarItem(title: "Goals", image: #imageLiteral(resourceName: "goals_icon"), tag: 1)
		navigationController.setNavigationBarHidden(true, animated: false)

		let settingsViewController = SettingsViewController(viewModel: SettingsViewModel())
		settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings_icon"), tag: 2)

		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [navigationController, settingsViewController]
		tabBarController.tabBar.tintColor = ColorLibrary.UIPalette.accent
		window?.rootViewController = tabBarController

		window?.makeKeyAndVisible()

		informationHeader = InformationHeader()

		if UserDefaults.standard.bool(forKey: "thisIsTheFirstLaunch") == false {
			print("First launch, setting UserDefaults.")
			UserDefaults.standard.set(true, forKey: "thisIsTheFirstLaunch")
			NotificationManager.clearAllNotifications()
		}

		UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
			for request in requests {
				print(request.identifier)
			}
		}

		return true
	}

}
