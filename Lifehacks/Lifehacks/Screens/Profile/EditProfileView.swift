//
//  EditProfileView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - EditProfileView
struct EditProfileView: View {
	@EnvironmentObject private var stateController: StateController
	@Environment(\.presentationMode) private var presentationMode
	
	@State private var name: String = ""
	@State private var aboutMe: String = ""
	@State private var avatar: UIImage = .init()
	
	@State private var pickingSource: Bool = false
	@State private var pickingImage: Bool = false
	@State private var source: UIImagePickerController.SourceType = .photoLibrary
	
	var body: some View {
		Content(name: $name, aboutMe: $aboutMe, avatar: avatar, save: save, cancel: dismiss) {
			pickingSource = true
		}
		.onAppear {
			let user = stateController.mainUser
			name = user.name
			aboutMe = user.aboutMe ?? ""
			avatar = user.avatar ?? UIImage()
		}
		.actionSheet(isPresented: $pickingSource) {
			ActionSheet(title: Text("Select a source"), message: Text(""), buttons: [
				.default(Text("Take photo"), action: takePhoto),
				.default(Text("Choose from Library"), action: pickPhoto),
				.cancel()
			])
		}
		.sheet(isPresented: $pickingImage) {
			ImagePicker(source: source, image: $avatar)
		}
	}
}

// MARK: Private
private extension EditProfileView {
	func dismiss() {
		presentationMode.wrappedValue.dismiss()
	}
	
	func save() {
		stateController.save(name: name, aboutMe: aboutMe, avatar: avatar)
		dismiss()
	}
	
	func takePhoto()  {
		// This crashes in the iOS simulator
		source = .camera
		pickingImage = true
	}
	
	func pickPhoto() {
		source = .photoLibrary
		pickingImage = true
	}
}

// MARK: - Content
fileprivate typealias Content = EditProfileView.Content

extension EditProfileView {
	struct Content: View {
		@Binding var name: String
		@Binding var aboutMe: String
		let avatar: UIImage
		
		let save: () -> Void
		let cancel: () -> Void
		let edit: () -> Void
		
		var body: some View {
			VStack {
				Header(name: $name, avatar: avatar, edit: edit)
				AboutMe(text: $aboutMe)
				Spacer()
			}
			.padding(20.0)
			.animation(.default, value: [name, aboutMe])
			.navigationTitle("Edit Profile")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel", action: cancel)
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Save", action: save)
				}
			}
		}
	}
}

// MARK: - Header
fileprivate typealias Header = Content.Header

extension Content {
	struct Header: View {
		@Binding var name: String
		let avatar: UIImage
		let edit: () -> Void
		
		var body: some View {
			HStack(alignment: .top) {
				ZStack {
					Image(uiImage: avatar)
						.round(borderColor: .accentColor)
						.frame(width: 62.0, height: 62.0)
					Button(action: edit) {
						Text("Edit")
							.bold()
							.foregroundColor(.white)
					}
				}
				VStack(alignment: .leading) {
					TextField("Name", text: $name)
					Divider()
					EditProfileView.ErrorMessage(
						text: "The name cannot be empty",
						isVisible: name.isEmpty)
				}
				.padding(.leading, 16.0)
			}
		}
	}
}

// MARK: - AboutMe
fileprivate typealias AboutMe = Content.AboutMe

extension Content {
	struct AboutMe: View {
		@Binding var text: String
		
		var body: some View {
			VStack(alignment: .leading) {
				Text("About me:")
					.font(.callout)
					.bold()
				TextEditor(text: $text)
					.frame(height: 200.0)
				EditProfileView.ErrorMessage(
					text: "The about me cannot be empty", 
					isVisible: text.isEmpty)
			}
		}
	}
}

// MARK: - ErrorMessage
fileprivate typealias ErrorMessage = EditProfileView.ErrorMessage

extension EditProfileView {
	struct ErrorMessage: View {
		let text: String
		var isVisible: Bool = false
		
		var body: some View {
			Group {
				if isVisible {
					Text(text)
						.font(.footnote)
						.bold()
						.motif(.secondary)
				}
			}
		}
	}
}

// MARK: - Previews
struct EditProfileView_Previews: PreviewProvider {
	static let user = TestData.user
	
	static var previews: some View {
		Group {
			NavigationView {
				Content(
					name: .constant(user.name),
					aboutMe: .constant(user.aboutMe!),
					avatar: user.avatar!,
					save: {},
					cancel: {},
					edit: {})
			}
			.fullScreenPreviews()
			VStack(spacing: 16.0) {
				Header(name: .constant(user.name), avatar: user.avatar!, edit: {})
				Header(name: .constant(""), avatar: user.avatar!, edit: {})
			}
			.previewWithName(String.name(for: Header.self))
			VStack(spacing: 16.0) {
				AboutMe(text: .constant(user.aboutMe!))
				AboutMe(text: .constant(""))
			}
			.previewWithName(String.name(for: AboutMe.self))
			ErrorMessage(text: "The name cannot be empty", isVisible: true)
				.namedPreview()
		}
	}
}
