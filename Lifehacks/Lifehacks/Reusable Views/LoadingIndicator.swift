//
//  LoadingIndicator.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

struct LoadingIndicator: View {
	let isLoading: Bool
	
	var body: some View {
		ProgressView("Loading...")
			.padding()
			.background(.regularMaterial, in: RoundedRectangle(cornerRadius: 8.0))
			.opacity(isLoading ? 1.0 : 0)
	}
}

extension View {
	func loading(_ isLoading: Bool) -> some View {
		self
			.redacted(reason: isLoading ? .placeholder : [])
			.overlay(LoadingIndicator(isLoading: isLoading))
	}
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator(isLoading: true)
			.namedPreview()
    }
}
