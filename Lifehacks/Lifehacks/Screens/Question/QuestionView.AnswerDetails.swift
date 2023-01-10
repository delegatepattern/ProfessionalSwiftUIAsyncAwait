//
//  QuestionView.AnswerDetails.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: AnswerDetails
fileprivate typealias AnswerDetails = QuestionView.Content.AnswerDetails

extension QuestionView.Content {
	struct AnswerDetails: View {
		@Binding var answer: Answer
		
		@Environment(\.navigationMap) private var navigationMap
		
		var body: some View {
			HStack(alignment: .top, spacing: 16.0) {
				VStack(spacing: 16.0) {
					QuestionView.Voting(
						score: answer.score,
						vote: .init(vote: answer.vote),
						upvote: { answer.upvote() },
						downvote: { answer.downvote() },
						unvote: { answer.unvote() })
					if answer.isAccepted {
						Image(systemName: "checkmark.circle.fill")
							.font(.largeTitle)
							.foregroundColor(.accentColor)
					}
				}
				VStack(alignment: .leading, spacing: 8.0) {
					Text(answer.body ?? "")
						.font(.subheadline)
					Text("Answered on \(answer.creationDate.formatted)")
						.font(.caption)
						.foregroundColor(.secondary)
					if let owner = answer.owner {
						HStack {
							Spacer()
							NavigationLink(
								destination: navigationMap.destinationForUser?(owner)) {
									QuestionView.Owner(user: owner)
										.style(.secondary)
								}
						}
						.padding(.top, 16.0)
					}
				}
			}
		}
	}
}

// MARK: - Previews
struct QuestionView_Answer_Previews: PreviewProvider {
	static let answer = TestData.answer
	
	static var previews: some View {
		AnswerDetails(answer: .constant(answer))
			.namedPreview()
	}
}
