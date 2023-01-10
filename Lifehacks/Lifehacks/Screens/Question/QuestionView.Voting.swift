//
//  QuestionView.Voting.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - Voting
fileprivate typealias Voting = QuestionView.Voting

extension QuestionView {
	struct Voting: View {
		let score: Int
		let vote: Vote
		let upvote: () -> Void
		let downvote: () -> Void
		let unvote: () -> Void
		
		var body: some View {
			AdaptiveView(standard: standardContent, large: largeContent)
		}
		
		func vote(_ vote: Vote) {
			switch (self.vote, vote) {
			case (.none, .up), (.down, .up): upvote()
			case (.none, .down), (.up, .down): downvote()
			default: unvote()
			}
		}
	}
}

// MARK: Private
private extension Voting {
	var content: some View {
		Group {
			VoteButton(buttonType: .up, highlighted: vote == .up, action: { self.vote(.up) })
			Text("\(score)")
				.font(.title)
				.foregroundColor(.secondary)
			VoteButton(buttonType: .down, highlighted: vote == .down, action: { self.vote(.down) })
		}
	}
	
	var standardContent: some View {
		VStack(spacing: 8.0) {
			content
		}
		.frame(minWidth: 56.0)
	}
	
	var largeContent: some View {
		HStack {
			content
		}
	}
}


extension Voting {
	enum Vote {
		case none
		case up
		case down
	}
}

extension Voting.Vote {
	init(vote: Vote) {
		switch vote {
		case .none: self = .none
		case .up: self = .up
		case .down: self = .down
		}
	}
}

// MARK: - VoteButton
fileprivate typealias VoteButton = Voting.VoteButton

extension Voting {
	struct VoteButton: View {
		let buttonType: ButtonType
		let highlighted: Bool
		let action: () -> Void
		
		var body: some View {
			Button(action: action) {
				buttonType.image(highlighted: highlighted)
					.resizable()
					.frame(width: 32, height: 32)
					.motif(.secondary)
			}
		}
	}
}

extension VoteButton {
	enum ButtonType: String {
		case up = "arrowtriangle.up"
		case down = "arrowtriangle.down"
		
		func image(highlighted: Bool) -> Image {
			let imageName = rawValue + (highlighted ? ".fill" : "")
			return Image(systemName: imageName)
		}
	}
}

// MARK: - Previews
struct QuestionView_Voting_Previews: PreviewProvider {
	static let question = TestData.question
	
	static var previews: some View {
		Group {
			HStack {
				Voting(score: question.score, vote: .none, upvote: {}, downvote: {}, unvote: {})
				Voting(score: question.score, vote: .up, upvote: {}, downvote: {}, unvote: {})
				Voting(score: question.score, vote: .down, upvote: {}, downvote: {}, unvote: {})
			}
			.previewWithName(String.name(for: Voting.self))
			Voting(score: question.score, vote: .none, upvote: {}, downvote: {}, unvote: {})
				.environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
				.previewWithName("XXXL")
			HStack(spacing: 16) {
				VoteButton(buttonType: .up, highlighted: true, action: {})
				VoteButton(buttonType: .up, highlighted: false, action: {})
				VoteButton(buttonType: .down, highlighted: true, action: {})
				VoteButton(buttonType: .down, highlighted: false, action: {})
			}
			.previewWithName(String.name(for: VoteButton.self))
		}
	}
}
