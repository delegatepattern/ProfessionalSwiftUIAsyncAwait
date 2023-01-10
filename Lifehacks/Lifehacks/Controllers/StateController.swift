//
//  StateController.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import UIKit
import Foundation

class StateController: ObservableObject {
	@Published private(set) var mainUser = TestData.user
	@Published var tags: [Tag] = []
	@Published var users: [User] = []
	
	@Published var topQuestions: [Question] {
		didSet { storageController.save(topQuestions: topQuestions) }
	}
	
	subscript(questionID: Int) -> Question {
		get { topQuestions[index(for: questionID)] }
		set { topQuestions[index(for: questionID)] = newValue }
	}
	
	private let storageController = StorageController()
	
	init() {
		topQuestions = storageController.fetchTopQuestions() ?? []
		mainUser = storageController.fetchUser() ?? TestData.user
	}
	
	func save(name: String, aboutMe: String, avatar: UIImage) {
		mainUser.name = name
		mainUser.aboutMe = aboutMe
		mainUser.avatar = avatar
		storageController.save(user: mainUser)
	}
}

private extension StateController {
	func index(for questionID: Int) -> Int {
		topQuestions.firstIndex(where: { $0.id == questionID })!
	}
}
