//
//  Logging.swift
//  PerfectWeek
//
//  Created by Evan Lewis on 5/20/17.
//  Copyright © 2017 evanlewis. All rights reserved.
//

import Foundation

func print(_ item: @autoclosure () -> Any, separator: String = " ", terminator: String = "\n") {
	#if DEBUG
		Swift.print(item(), separator:separator, terminator: terminator)
	#endif
}

@discardableResult
func guardFailureWarning(_ message: String) -> String {
	let warningMessage = "Guard failure warning: \(message)"
	print(warningMessage)
	return warningMessage
}
