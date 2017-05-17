//
//  SettingsViewController.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/10/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import UIKit
import MessageUI

final class SettingsViewController: UIViewController {

	let viewModel: SettingsViewModel
	let tableView = UITableView()

	init(viewModel: SettingsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		configureViews()
		configureConstraints()
	}

	// MARK: - Setup
	private func configureViews() {
		tableView.delegate = self
		tableView.dataSource = viewModel
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
		view.addSubview(tableView)
	}

	private func configureConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: InformationHeader.windowSize.height),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
		])
	}

}

extension SettingsViewController: UITableViewDelegate, MFMailComposeViewControllerDelegate {

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if MFMailComposeViewController.canSendMail() {
			InformationHeaderObserver.shouldHideInformationHeader()
			let mail = MFMailComposeViewController()
			mail.mailComposeDelegate = self
			mail.setSubject(LocalizedStrings.mailSubject)
			mail.setToRecipients([viewModel.mailRecipient])
			present(mail, animated: true, completion: nil)
		}
	}

	func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
		dismiss(animated: true) {
			InformationHeaderObserver.shouldShowInformationHeader()
		}
	}

}
