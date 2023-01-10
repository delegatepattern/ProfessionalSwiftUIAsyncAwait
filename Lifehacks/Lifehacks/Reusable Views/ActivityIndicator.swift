//
//  ActivityIndicator.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.


import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
	let style: UIActivityIndicatorView.Style
	var isAnimating: Bool = true
	
	func makeUIView(
		context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
			UIActivityIndicatorView(style: style)
	}
	
	func updateUIView(
		_ uiView: UIActivityIndicatorView,
		context: UIViewRepresentableContext<ActivityIndicator>) {
			isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
	}
}
