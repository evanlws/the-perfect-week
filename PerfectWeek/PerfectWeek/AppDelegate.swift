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

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .white
		window?.rootViewController = GoalsViewController()
		window?.makeKeyAndVisible()
		return true
	}

}
