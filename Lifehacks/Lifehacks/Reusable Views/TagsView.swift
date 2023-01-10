//
//  TagsView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

struct TagsView: View {
	let tags: [String]
	
	var body: some View {
		Text(tagsString)
			.font(.footnote)
			.fontWeight(.semibold)
			.foregroundColor(.accentColor)
	}
}

private extension TagsView {
	var tagsString: String {
		var result = tags.first ?? ""
		for tag in tags.dropFirst() {
			result.append(", " + tag)
		}
		return result
	}
}

// MARK: - Previews
struct TagsView_Previews: PreviewProvider {
    static var previews: some View {
		TagsView(tags: ["lorem", "ipsum", "dolor", "sit", "amet"])
			.previewLayout(.sizeThatFits)
    }
}
