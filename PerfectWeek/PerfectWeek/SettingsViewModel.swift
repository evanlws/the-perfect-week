//
//  SettingsViewModel.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/16/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit

final class SettingsViewModel: NSObject {

	let mailRecipient = "evanlwsapps+theperfectweekhelp@gmail.com"

}

extension SettingsViewModel: UITableViewDataSource {

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
		cell.textLabel?.text = LocalizedStrings.sendFeedback
		return cell
	}

}
