//
//  TopUsersView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import SwiftUI

// MARK: - TopUsersView
struct TopUsersView: View {
	@EnvironmentObject private var stateController: StateController
	@StateObject private var viewModel = ViewModel()
	
	var body: some View {
		Content(users: stateController.users)
			.loading(viewModel.isLoading)
			.environment(\.navigationMap, NavigationMap(
				destinationForUser: { ProfileView(user: $0) }))
			.task {
				guard let users = await viewModel.loadUsers() else { return }
				stateController.users = users
			}
	}
}

// MARK: - Content
fileprivate typealias Content = TopUsersView.Content

extension TopUsersView {
	struct Content: View {
		let users: [User]
		
		@ScaledMetric private var columnWidth: CGFloat = 140.0
		@Environment(\.navigationMap) private var navigationMap
		
		var body: some View {
			ScrollView {
				LazyVGrid(columns: columns, alignment: .leading, spacing: 24.0) {
					ForEach(users) { user in
						NavigationLink(destination: navigationMap.destinationForUser?(user)) {
							Cell(user: user)
						}
					}
				}
				.padding(.top, 24.0)
				.padding(.leading, 20.0)
				.buttonStyle(.plain)
			}
			.navigationTitle("Users")
		}
	}
}

private extension Content {
	var columns: [GridItem] {
		[GridItem(.adaptive(minimum: columnWidth))]
	}
}

// MARK: - Cell
extension Content {
	struct Cell: View {
		let name: String
		let reputation: Int
		let avatarURL: URL?
		
		@ScaledMetric private var avatarSize: CGFloat = 37.0
		@ScaledMetric private var spacing: CGFloat = 8.0
		
		var body: some View {
			HStack(spacing: spacing) {
				AsyncRoundImage(url: avatarURL)
					.frame(width: avatarSize, height: avatarSize)
				VStack(alignment: .leading, spacing: 4.0) {
					Text(name)
						.font(.subheadline)
						.bold()
					Text("\(reputation.formatted) reputation")
						.font(.caption2)
						.foregroundColor(.secondary)
				}
			}
		}
	}
}

extension Content.Cell {
	init(user: User) {
		name = user.name
		reputation = user.reputation
		avatarURL = user.profileImageURL
	}
}

// MARK: - Previews
struct TopUsersView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			Content(users: TestData.users)
		}
		.fullScreenPreviews()
	}
}
