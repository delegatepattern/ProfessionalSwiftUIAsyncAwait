//
//  QuestionView.ViewModel.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation
import UIKit

extension QuestionView {
	@MainActor class ViewModel: ObservableObject {
		@Published var isLoading = false

		func loadDetails(for question: Question) async -> Question? {
			isLoading = true
			defer { isLoading = false }
			let resource = QuestionsResource(id: question.id)
			let request = APIRequest(resource: resource)
			guard let questions = await request.execute() else { return nil }
			return questions.first
		}
	}
}
