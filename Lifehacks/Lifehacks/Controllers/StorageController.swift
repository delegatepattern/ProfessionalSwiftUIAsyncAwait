//
//  StorageController.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation
import UIKit

class StorageController {
	private let documentsDirectoryURL = FileManager.default
		.urls(for: .documentDirectory, in: .userDomainMask)
		.first!
	
	func save(topQuestions: [Question]) {
		if let data = try? PropertyListEncoder().encode(topQuestions) {
			try? data.write(to: questionsFileURL)
		}
	}
	
	func fetchTopQuestions() -> [Question]? {
		guard let data = try? Data(contentsOf: questionsFileURL) else { return nil }
		return try? PropertyListDecoder().decode([Question].self, from: data)
	}
	
	func save(user: User) {
		let user = User(
			id: user.id,
			reputation: user.reputation,
			name: user.name,
			aboutMe: user.aboutMe,
			avatar: user.avatar,
			profileImageURL: avatarFileURL,
			userType: user.userType)
		guard let userData = try? PropertyListEncoder().encode(user) else { return }
		try? userData.write(to: userFileURL)
		let avatarData = user.avatar?.jpegData(compressionQuality: 1.0)
		try? avatarData?.write(to: avatarFileURL)
	}
	
	func fetchUser() -> User? {
		guard let userData = try? Data(contentsOf: userFileURL) else { return nil }
		guard var user = try?
				PropertyListDecoder().decode(User.self, from: userData) else { return nil }
		if let avatarData = try? Data(contentsOf: avatarFileURL),
			let avatar = UIImage(data: avatarData) {
			user.avatar = avatar
		}
		return user
	}
}

private extension StorageController {
	var questionsFileURL: URL {
		documentsDirectoryURL
			.appendingPathComponent("Question")
			.appendingPathExtension("plist")
	}
	
	var userFileURL: URL {
		documentsDirectoryURL
			.appendingPathComponent("User")
			.appendingPathExtension("plist")
	}
	
	var avatarFileURL: URL {
		documentsDirectoryURL
			.appendingPathComponent("avatar")
			.appendingPathExtension("jpg")
	}
}
