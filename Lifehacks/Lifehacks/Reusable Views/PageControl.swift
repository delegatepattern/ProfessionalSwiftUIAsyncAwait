//
//  PageControl.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - PageControl
struct PageControl: UIViewRepresentable {
	@Binding var currentPage: Int
	
	func makeCoordinator() -> Coordinator {
		Coordinator(pageControl: self)
	}
	
	func makeUIView(context: Context) -> UIPageControl {
		let pageControl = UIPageControl()
		pageControl.addTarget(context.coordinator, action: #selector(Coordinator.getPage), for: .touchUpInside)
		return pageControl
	}
	
	func updateUIView(_ uiView: UIPageControl, context: Context) {
		uiView.currentPage = currentPage
	}
}

// MARK: - Coordinator
extension PageControl {
	class Coordinator {
		let pageControl: PageControl
		
		init(pageControl: PageControl) {
			self.pageControl = pageControl
		}
		
		@objc func getPage(sender: UIPageControl) {
			pageControl.currentPage = sender.currentPage
		}
	}
}
