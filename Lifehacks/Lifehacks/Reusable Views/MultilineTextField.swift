//
//  TextView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - MultilineTextField
struct MultilineTextField: UIViewRepresentable {
	@Binding var text: String
	
	func makeCoordinator() -> Coordinator {
		Coordinator(textView: self)
	}
	
	func makeUIView(context: Context) -> UITextView {
		let textView = UITextView()
		textView.font = .preferredFont(forTextStyle: .body)
		textView.textContainerInset = .zero
		textView.textContainer.lineFragmentPadding = 0.0
		textView.delegate = context.coordinator
		return textView
	}
	
	func updateUIView(_ uiView: UITextView, context: Context) {
		uiView.text = text
	}
}

// MARK: - Coordinator
extension MultilineTextField {
	class Coordinator: NSObject, UITextViewDelegate {
		let textView: MultilineTextField
		
		init(textView: MultilineTextField) {
			self.textView = textView
		}
		
		func textViewDidChange(_ textView: UITextView) {
			self.textView.text = textView.text
		}
	}
}

// MARK: - Previews
struct TextView_Previews: PreviewProvider {
	static var previews: some View {
		MultilineTextField(text: .constant(TestData.user.aboutMe!))
			.namedPreview()
			.frame(height: 250.0)
	}
}
