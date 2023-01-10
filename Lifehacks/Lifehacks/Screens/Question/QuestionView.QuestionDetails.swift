//
//  QuestionView.QuestionDetails.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - QuestionDetails
fileprivate typealias QuestionDetails = QuestionView.Content.QuestionDetails

extension QuestionView.Content {
	struct QuestionDetails: View {
		@Binding var question: Question
		let jumpToAnswer: () -> Void
		
		@Environment(\.navigationMap) private var navigationMap
		
		var body: some View {
			VStack(alignment: .leading, spacing: 24.0) {
				AdaptiveView(
					standard: HStack(alignment: .top, spacing: 16.0) { topContent },
					large: VStack { topContent })
				if question.isAnswered {
					Button("Go to accepted answer", action: jumpToAnswer)
						.font(Font.footnote.bold())
				}
				Text(question.body ?? "")
					.font(.subheadline)
				if let owner = question.owner {
					HStack {
						AdaptiveView(standard: Spacer(), large: EmptyView())
						NavigationLink(destination: navigationMap.destinationForUser?(owner)) {
							QuestionView.Owner(user: owner)
								.style(.primary)
						}
					}
				}
			}
		}
	}
}

// MARK: Private
private extension QuestionDetails {
	var topContent: some View {
		Group {
			QuestionView.Voting(
				score: question.score,
				vote: .init(vote: question.vote),
				upvote: { question.upvote() },
				downvote: { question.downvote() },
				unvote: { question.unvote() }
			)
			Info(
				title: question.title,
				viewCount: question.viewCount,
				date: question.creationDate,
				tags: question.tags)
		}
	}
}

// MARK: - Info
fileprivate typealias Info = QuestionDetails.Info

extension QuestionDetails {
	struct Info: View {
		let title: String
		let viewCount: Int
		let date: Date
		let tags: [String]
		
		var body: some View {
			VStack(alignment: .leading, spacing: 8.0) {
				Text(title)
					.font(.headline)
				TagsView(tags: tags)
				Group {
					Text("Asked on \(date.formatted)")
					Text("Viewed \(viewCount.formatted) times")
				}
				.font(.caption)
				.foregroundColor(.secondary)
			}
		}
	}
}

// MARK: - Previews
struct QuestionView_Details_Previews: PreviewProvider {
	static let question = TestData.question

	static var previews: some View {
		Group {
			QuestionDetails(question: .constant(question), jumpToAnswer: {})
				.namedPreview()
			QuestionDetails(question: .constant(question), jumpToAnswer: {})
				.environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
				.previewWithName(String.name(for: QuestionDetails.self) + " XXXL")
			Info(
				title: question.title,
				viewCount: question.viewCount,
				date: question.creationDate,
				tags: question.tags)
				.namedPreview()
		}
	}
}
