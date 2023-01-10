//
//  SettingsController.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation

class SettingsController: ObservableObject {
	@Published var theme: Theme {
		didSet { defaults.set(theme.name, forKey: LifehacksApp.Keys.themeName) }
	}
	
	private let defaults = UserDefaults.standard
	
	init() {
		let themeName = defaults.string(forKey: LifehacksApp.Keys.themeName) ?? ""
		theme = Theme.named(themeName) ?? .default
	}
}
