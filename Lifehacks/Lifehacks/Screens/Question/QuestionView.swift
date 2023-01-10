//
//  QuestionView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - QuestionView
struct QuestionView: View {
	let question: Question

	@EnvironmentObject private var stateController: StateController
	@StateObject private var viewModel = ViewModel()
	
	var body: some View {
		Content(question: $stateController[question.id])
			.loading(viewModel.isLoading)
			.environment(\.navigationMap, NavigationMap(destinationForUser: destination(for:)))
			.task {
				guard let question = await viewModel.loadDetails(for: question) else { return }
				stateController[question.id] = question
			}
	}
}

private extension QuestionView {
	func destination(for user: User) -> ProfileView {
		ProfileView(user: user, isMainUser: user.id == stateController.mainUser.id)
	}
}

// MARK: - Content
fileprivate typealias Content = QuestionView.Content

extension QuestionView {
	struct Content: View {
		@Binding var question: Question
		
		var body: some View {
			ScrollViewReader { scrolling in
				ScrollView {
					LazyVStack {
						QuestionDetails(
							question: $question,
							jumpToAnswer: { jumpToAnswer(with: scrolling) })
							.padding(.horizontal, 20.0)
							.padding(.bottom)
						if let comments = question.comments {
							PaddedDivider()
							Comments(comments: comments)
						}
						ForEach(answers) { $answer in
							AnswerDetails(answer: $answer)
								.padding(.horizontal, 20.0)
								.padding(.vertical, 24.0)
								.id(answer.id)
							PaddedDivider()
						}
					}
				}
				.navigationTitle("Question")
			}
		}
	}
}

private extension Content {
	func jumpToAnswer(with scrolling: ScrollViewProxy) {
		guard let acceptedAnswer = question.answers?.first(where: { $0.isAccepted }) else {
			return
		}
		withAnimation {
			scrolling.scrollTo(acceptedAnswer.id, anchor: .top)
		}
	}
	
	var answers: Binding<[Answer]> {
		Binding(
			get: { question.answers ?? [] },
			set: { question.answers = $0 })
	}
}

// MARK: - PaddedDivider
fileprivate typealias PaddedDivider = QuestionView.PaddedDivider

extension QuestionView {
	struct PaddedDivider: View {
		var body: some View {
			Divider()
				.padding(.leading, 20.0)
		}
	}
}

// MARK: - Owner
fileprivate typealias Owner = QuestionView.Owner

extension QuestionView {
	struct Owner: View {
		let name: String
		let reputation: Int
		let avatarURL: URL?
		
		var body: some View {
			HStack {
				AsyncRoundImage(url: avatarURL)
					.frame(width: 48.0, height: 48.0)
				VStack(alignment: .leading, spacing: 4.0) {
					Text(name)
						.font(.headline)
					Text("\(reputation.formatted) reputation")
						.font(.caption)
				}
			}
			.padding(16)
		}
	}
}

extension Owner {
	init(user: User) {
		name = user.name
		reputation = user.reputation
		avatarURL = user.profileImageURL
	}
}

// MARK: - Comments
fileprivate typealias Comments = Content.Comments

extension Content {
	struct Comments: View {
		let comments: [Lifehacks.Comment]
		
		var body: some View {
			GeometryReader { geometry in
				TabView {
					ForEach(comments) { comment in
						Comment(comment: comment)
							.frame(width: geometry.size.width - 40.0)
					}
				}
				.tabViewStyle(PageTabViewStyle())
			}
			.frame(height: 174.0)
			.padding(.vertical)
		}
	}
}

// MARK: - Comment
extension Comments {
	struct Comment: View {
		let comment: Lifehacks.Comment
		
		@Environment(\.navigationMap) private var navigationMap
		
		var body: some View {
			VStack(alignment: .leading, spacing: 8.0) {
				Text(comment.body ?? "")
					.lineLimit(5)
				if let owner = comment.owner {
					NavigationLink(destination: navigationMap.destinationForUser?(owner)) {
						Text(owner.name)
							.foregroundColor(.accentColor)
					}
				}
			}
			.font(.subheadline)
			.padding(24.0)
			.background(Color(UIColor.systemGray6))
			.cornerRadius(6.0)
		}
	}
}

// MARK: - Previews
struct QuestionView_Previews: PreviewProvider {
	static let question = TestData.question
	static let user = TestData.user
	static let comment = TestData.comment
	
	static var previews: some View {
		Group {
			NavigationView {
				Content(question: .constant(question))
			}
			.fullScreenPreviews()
			Owner(user: user)
				.style(.primary)
				.previewWithName(.name(for: Owner.self))
			Comments(comments: question.comments!)
				.namedPreview()
			Comments.Comment(comment: comment)
				.namedPreview()
		}
	}
}
