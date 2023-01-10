//
//  Extensions.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation

extension Int {
	var formatted: String {
		if #available(iOS 15, *) {
			return self.formatted()
		} else {
			let formatter = NumberFormatter()
			formatter.numberStyle = .decimal
			return formatter.string(from: NSNumber(value: self)) ?? ""
		}
	}
}

extension Date {
	var formatted: String {
		if #available(iOS 15, *) {
			return self.formatted(date: .abbreviated, time: .omitted)
		} else {
			let formatter = DateFormatter()
			formatter.dateStyle = .medium
			return formatter.string(from: self)
		}
	}
}
