//
//  TopTagsView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import SwiftUI

// MARK: - TopTagsView
struct TopTagsView: View {
	@EnvironmentObject private var stateController: StateController
	@StateObject private var viewModel = ViewModel()
	
	var body: some View {
		Content(tags: stateController.tags)
			.loading(viewModel.isLoading)
			.environment(\.navigationMap, NavigationMap(
				destinationForQuestion: {QuestionView(question: $0) }))
			.task {
				guard let tags = await viewModel.loadTags() else { return }
				stateController.tags = tags
			}
	}
}

// MARK: - Content
fileprivate typealias Content = TopTagsView.Content

extension TopTagsView {
	struct Content: View {
		let tags: [Tag]
		
		@Environment(\.navigationMap) private var navigationMap
		
		var body: some View {
			List {
				ForEach(tags) { tag in
					DisclosureGroup {
						if let questions = tag.questions {
							ForEach(questions) { question in
								NavigationLink(
									destination: navigationMap.destinationForQuestion?(question)) {
										QuestionRow(question: question)
									}
							}
						}
					} label: {
						Header(title: tag.name, count: tag.count, excerpt: tag.excerpt ?? "")
					}
				}
			}
			.listStyle(.plain)
			.navigationTitle("Tags")
		}
	}
}

// MARK: - Header
extension Content {
	struct Header: View {
		let title: String
		let count: Int
		let excerpt: String
		
		var body: some View {
			VStack(spacing: 8.0) {
				HStack {
					Text(title)
					Spacer()
					Text("\(count)")
				}
				.font(.headline)
				Text(excerpt)
					.font(.footnote)
					.foregroundColor(.secondary)
					.frame(maxWidth: .infinity, alignment: .leading)
			}
			.padding(.vertical, 8.0)
		}
	}
}

// MARK: - Previews
struct TopTagsView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			Content(tags: TestData.topTags)
		}
	}
}
