//
//  TopTagsView.ViewModel.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import Foundation

extension TopTagsView {
	@MainActor class ViewModel: ObservableObject {
		@Published var isLoading = false

		func loadTags() async -> [Tag]? {
			isLoading = true
			defer { isLoading = false }
			let request = APIRequest(resource: TagsResource())
			guard let tags = await request.execute() else { return nil }
			return await loadDetails(for: tags)
		}
	}
}

private extension TopTagsView.ViewModel {
	func loadExcerpt(for tag: Tag) async -> String? {
		let wikiResource = TagWikiResource(name: tag.name)
		let wikiRequest = APIRequest(resource: wikiResource)
		return await wikiRequest.execute()?.first?.text
	}
	
	func loadQuestions(for tag: Tag) async -> [Question]? {
		let resource = QuestionsResource(tag: tag.name)
		let request = APIRequest(resource: resource)
		return await request.execute()
	}
	
	func loadDetails(for tag: Tag) async -> Tag {
		async let excerpt = loadExcerpt(for: tag)
		async let questions = loadQuestions(for: tag)
		return await Tag(
			count: tag.count,
			name: tag.name,
			excerpt: excerpt,
			questions: questions)
	}
	
	func loadDetails(for tags: [Tag]) async -> [Tag] {
		var details: [Tag] = []
		await withTaskGroup(of: Tag.self) { group in
			for tag in tags {
				group.addTask { [weak self] in
					guard let self = self else { return tag }
					return await self.loadDetails(for: tag)
				}
			}
			for await tag in group {
				details.append(tag)
			}
		}
		return details.sorted { $0.count > $1.count }
	}
}
