//
//  QuestionRow.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import SwiftUI

// MARK: - QuestionRow
struct QuestionRow: View {
	let title: String
	let tags: [String]
	let score: Int
	let answerCount: Int
	let viewCount: Int
	let date: Date
	let name: String
	let isAnswered: Bool
	
	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(title)
				.font(.headline)
			TagsView(tags: tags)
			HStack(alignment: .center, spacing: 16) {
				Counter(count: score, label: "votes")
					.style(.primary)
				Counter(count: answerCount, label: "answers")
					.style(.secondary, filled: isAnswered)
				Details(viewCount: viewCount, date: date, name: name)
			}
			.padding(.vertical, 8)
		}
		.padding(.top, 16)
	}
}

extension QuestionRow {
	init(question: Question) {
		self.init(
			title: question.title,
			tags: question.tags,
			score: question.score,
			answerCount: question.answerCount,
			viewCount: question.viewCount,
			date: question.creationDate,
			name: question.owner?.name ?? "",
			isAnswered: question.isAnswered)
	}
}

// MARK: - Counter
fileprivate typealias Counter = QuestionRow.Counter

extension QuestionRow {
	struct Counter: View {
		let count: Int
		let label: String
		
		var body: some View {
			VStack {
				Text("\(count)")
					.font(.title3)
					.bold()
				Text(label)
					.font(.caption)
			}
			.frame(width: 67, height: 67)
		}
	}
}

// MARK: - Details
fileprivate typealias Details = QuestionRow.Details

extension QuestionRow {
	struct Details: View {
		let viewCount: Int
		let date: Date
		let name: String
		
		var body: some View {
			VStack(alignment: .leading, spacing: 4.0) {
				Text("\(viewCount.formatted) views")
				Text("Asked on \(date.formatted)")
				Text(name)
			}
			.font(.caption)
			.foregroundColor(.secondary)
		}
	}
}

// MARK: - Previews
struct QuestionRow_Previews: PreviewProvider {
	static let question = TestData.question
	static let questions = TestData.questions
	
    static var previews: some View {
		Group {
			QuestionRow(question: question)
				.namedPreview()
			Details(
				viewCount: question.viewCount,
				date: question.creationDate,
				name: question.owner!.name)
				.namedPreview()
			HStack {
				Counter(count: question.score, label: "votes")
					.blueStyle()
				Counter(count: question.answerCount, label: "answers")
					.orangeStyle(filled: true)
				Counter(count: question.answerCount, label: "answers")
					.orangeStyle(filled: false)
			}
			.previewWithName(.name(for: Counter.self))
		}
    }
}
