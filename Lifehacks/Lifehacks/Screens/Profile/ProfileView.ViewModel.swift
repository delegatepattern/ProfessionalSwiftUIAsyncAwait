//
//  ProfileView.ViewModel.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation
import UIKit

extension ProfileView {
	@MainActor class ViewModel: ObservableObject {
		@Published var isLoading = false

		func loadAboutMe(for user: User) async -> String? {
			isLoading = true
			defer { isLoading = false }
			let resource = UsersResource(id: user.id)
			let request = APIRequest(resource: resource)
			guard let users = await request.execute() else { return nil }
			return users.first?.aboutMe
		}
	}
}
