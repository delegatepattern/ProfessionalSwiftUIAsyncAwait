//
//  String.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation

extension String {
	var htmlString: NSAttributedString? {
		guard let htmlData = self.data(using: .unicode) else { return nil }
		let options = [
			NSAttributedString.DocumentReadingOptionKey.documentType:
				NSAttributedString.DocumentType.html]
		return try? NSAttributedString(data: htmlData, options: options, documentAttributes: nil)
	}
	
	var plainHtmlString: String {
		return htmlString?.string ?? ""
	}
}
