//
//  AppDelegate.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 2/18/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var informationHeader: InformationHeader?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white

		let goalsViewController = GoalsViewController()
		goalsViewController.viewModel = GoalsViewModel()
		let navigationController = UINavigationController(rootViewController: goalsViewController)
		navigationController.tabBarItem = UITabBarItem(title: "Goals", image: nil, tag: 1)
		navigationController.setNavigationBarHidden(true, animated: false)

		let settingsViewController = UIViewController()
		settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: nil, tag: 2)

		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [navigationController, settingsViewController]
		window?.rootViewController = tabBarController

		window?.makeKeyAndVisible()

		informationHeader = InformationHeader()
		return true
	}

}
