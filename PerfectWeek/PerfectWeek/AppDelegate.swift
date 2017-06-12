//
//  AppDelegate.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/18/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var informationHeader: InformationHeader?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

		#if RELEASE
			Fabric.with([Crashlytics.self])
		#endif

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white

		let goalsViewController = GoalsViewController(viewModel: GoalsViewModel())
		let navigationController = UINavigationController(rootViewController: goalsViewController)
		navigationController.tabBarItem = UITabBarItem(title: "Goals", image: #imageLiteral(resourceName: "goals_icon"), tag: 1)
		navigationController.setNavigationBarHidden(true, animated: false)

		let statsViewController = StatsViewController(viewModel: StatsViewModel())
		statsViewController.tabBarItem = UITabBarItem(title: "Stats", image: #imageLiteral(resourceName: "stats_icon"), tag: 2)

		let settingsViewController = SettingsViewController(viewModel: SettingsViewModel())
		settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: #imageLiteral(resourceName: "settings_icon"), tag: 3)

		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [navigationController, statsViewController, settingsViewController]
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
