//
//  Theme.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - Theme
struct Theme: Identifiable {
	let name: String
	let accentColor: Color
	let secondaryColor: Color
	let primaryGradient: LinearGradient
	let secondaryGradient: LinearGradient
	
	var id: String { name }
	
	static let `default` = Theme(
		name: "Default",
		accentColor: .blue,
		secondaryColor: .orange,
		primaryGradient: .blue,
		secondaryGradient: .orange)
	
	static let web = Theme(
		name: "Web",
		accentColor: .teal,
		secondaryColor: .green,
		primaryGradient: .teal,
		secondaryGradient: .green)
	
	static let allThemes: [Theme] = [.default, .web]
	
	static func named(_ name: String) -> Theme? {
		allThemes.first(where: { $0.name == name })
	}
}

// MARK: - ThemeKey
struct ThemeKey: EnvironmentKey {
	static let defaultValue = Theme.default
}

// MARK: - EnvironmentValues
extension EnvironmentValues {
	var theme: Theme {
		get { self[ThemeKey.self] }
		set { self[ThemeKey.self] = newValue  }
	}
}
