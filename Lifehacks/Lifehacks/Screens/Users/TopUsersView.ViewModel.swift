//
//  TopUsersView.ViewModel.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import Foundation

extension TopUsersView {
	@MainActor class ViewModel: ObservableObject {
		@Published var isLoading = false
				
		func loadUsers() async -> [User]? {
			isLoading = true
			defer { isLoading = false }
			let request = APIRequest(resource: UsersResource())
			return await request.execute()
		}
	}
}
