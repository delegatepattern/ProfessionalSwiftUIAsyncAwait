//
//  URL.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation

extension URL {
	func appendingParameters(_ parameters: [String: String]) -> URL {
		var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: false)!
		var queryItems = urlComponents.queryItems ?? []
		for key in parameters.keys {
			queryItems.append(URLQueryItem(name: key, value: parameters[key]))
		}
		urlComponents.queryItems = queryItems
		return urlComponents.url!
	}
}
