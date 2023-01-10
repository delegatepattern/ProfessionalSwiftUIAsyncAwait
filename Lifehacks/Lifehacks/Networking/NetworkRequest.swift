//
//  NetworkRequest.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import Foundation
import UIKit

// MARK: - NetworkRequest
protocol NetworkRequest {
	associatedtype ModelType
	var url: URL { get }
	func decode(_ data: Data) -> ModelType?
}

extension NetworkRequest {
	func execute() async -> ModelType? {
		guard let (data, _) = try? await URLSession.shared.data(from: url) else { return nil }
		return decode(data)
	}
}

// MARK: - ImageRequest
struct ImageRequest {
	let url: URL
}

// MARK: NetworkRequest
extension ImageRequest: NetworkRequest {
	func decode(_ data: Data) -> UIImage? {
		return UIImage(data: data)
	}
}

// MARK: - APIRequest
struct APIRequest<Resource: APIResource> {
	let resource: Resource
}

// MARK: NetworkRequest
extension APIRequest: NetworkRequest {
	var url: URL {
		return resource.url
	}
	
	func decode(_ data: Data) -> [Resource.ModelType]? {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .secondsSince1970
		let wrapper = try? decoder.decode(Wrapper<Resource.ModelType>.self, from: data)
		return wrapper?.items
	}
}
