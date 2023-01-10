//
//  TopQuestionsView.ViewModel.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import Foundation

extension TopQuestionsView {
	@MainActor class ViewModel: ObservableObject {
		@Published var isLoading = false
		
		func fetchTopQuestions() async -> [Question]? {
			isLoading = true
			defer { isLoading = false }
			let resource = QuestionsResource()
			let request = APIRequest(resource: resource)
			return await request.execute()
		}
	}
}
