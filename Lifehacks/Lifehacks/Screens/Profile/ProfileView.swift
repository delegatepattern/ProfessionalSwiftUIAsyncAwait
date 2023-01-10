//
//  ProfileView.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.


import SwiftUI

// MARK: - ProfileView
struct ProfileView : View {
	@State var user: User
	var isMainUser: Bool = false
	
	@State private var isEditing = false
	@EnvironmentObject private var settingsController: SettingsController
	@StateObject private var viewModel = ViewModel()
	
	var body: some View {
		Content(user: user, isMainUser: isMainUser, editAction: { isEditing = true })
			.loading(viewModel.isLoading)
			.task {
				guard !isMainUser else { return }
				user.aboutMe = await viewModel.loadAboutMe(for: user)
			}
			.fullScreenCover(isPresented: $isEditing) {
				NavigationView {
					EditProfileView()
				}
				.accentColor(settingsController.theme.accentColor)
			}
	}
}

// MARK: - Content
fileprivate typealias Content = ProfileView.Content

extension ProfileView {
	struct Content : View {
		let user: User
		let isMainUser: Bool
		let editAction: () -> Void
		
		var body: some View {
			ScrollView {
				Header(
					avatarURL: user.profileImageURL,
					name: user.name,
					reputation: user.reputation,
					isMainUser: isMainUser)
				Text(user.aboutMe ?? "")
					.padding(.top, 16.0)
					.padding(.horizontal, 20.0)
			}
			.navigationTitle(Text("Profile"))
			.toolbar {
				ToolbarItem(placement: .primaryAction, content: { editButton })
			}
		}
	}
}

// MARK: Private
private extension Content {
	var editButton: Button<Text>? {
		guard isMainUser else { return nil }
		return Button(action: editAction) {
			Text("Edit")
		}
	}
}

// MARK: - Header
fileprivate typealias Header = ProfileView.Header

extension ProfileView {
	struct Header: View {
		let avatarURL: URL?
		let name: String
		let reputation: Int
		var isMainUser: Bool = false

		var body: some View {
			VStack(spacing: 4.0) {
				AsyncRoundImage(url: avatarURL)
					.frame(width: 144, height: 144)
				Text(name)
					.font(.title)
					.bold()
					.padding(.top, 12.0)
				Text("\(reputation.formatted) reputation")
					.font(.headline)
			}
			.frame(maxWidth: .infinity)
			.padding([.top, .bottom], 24)
			.style(isMainUser ? .primary : .secondary, rounded: false)
		}
	}
}

// MARK: - Previews
struct ProfileView_Previews : PreviewProvider {
	static let user = TestData.user
	static let otherUser = TestData.otherUser
	
    static var previews: some View {
		Group {
			NavigationView {
				Content(user: user, isMainUser: true, editAction: {})
			}
			.fullScreenPreviews()
			VStack {
				Header(
					avatarURL: otherUser.profileImageURL,
					name: otherUser.name,
					reputation: otherUser.reputation)
				Header(
					avatarURL: user.profileImageURL,
					name: user.name,
					reputation: user.reputation,
					isMainUser: true)
			}
			.previewWithName(.name(for: Header.self))
		}
    }
}
