//
//  RoundImage.swift
//  Lifehacks
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI
import UIKit

struct RoundImage: View {
	let image: UIImage
	var borderColor: Color = .white
	
	var body: some View {
		Image(uiImage: image)
			.round(borderColor: borderColor)
	}
}

extension Image {
	func round(borderColor: Color = .white) -> some View {
		self
			.resizable()
			.clipShape(Circle())
			.overlay(
				Circle().stroke(borderColor, lineWidth: 2))
	}
}

struct AsyncRoundImage: View {
	let url: URL?
	
	var body: some View {
		if let url = url {
			AsyncImage(url: url) { image in
				image.round()
			} placeholder: {
				ProgressView()
			}
		}
	}
}

struct RoundImage_Previews : PreviewProvider {
    static var previews: some View {
		RoundImage(image: TestData.user.avatar!)
			.frame(width: 100, height: 100)
			.padding()
			.background(Color.black)
			.previewLayout(.sizeThatFits)
    }
}
