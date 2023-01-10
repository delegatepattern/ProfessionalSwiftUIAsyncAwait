//
//  TopQuestionsView.swift
//  Lifehacks (SwiftUI)
//
//  Created by Qasim Al Mahammedi on 1/10/23.

import SwiftUI

// MARK: - TopQuestionsView
struct TopQuestionsView: View {
	@EnvironmentObject private var stateController: StateController
	@StateObject private var viewModel = ViewModel()
	@State private var isErrorAlertPresented = false
	
	var body: some View {
		Content(questions: $stateController.topQuestions)
			.loading(viewModel.isLoading)
			.environment(\.navigationMap, NavigationMap(
				destinationForQuestion: { QuestionView(question: $0) }))
			.onAppear {
				// We use .onAppear instead of .task to work around a SwiftUI bug.
				Task { await update() }
			}
			.refreshable { await update() }
			.alert(isPresented: $isErrorAlertPresented) {
				Alert(title: Text("There was an error"), message: Text("Please try again later"))
			}
	}
}

private extension TopQuestionsView {
	func update() async {
		guard let questions = await viewModel.fetchTopQuestions() else {
			isErrorAlertPresented = true
			return
		}
		stateController.topQuestions = questions
	}
}

// MARK: - Content
fileprivate typealias Content = TopQuestionsView.Content

extension TopQuestionsView {
	struct Content: View {
		@Binding var questions: [Question]
		
		@Environment(\.navigationMap) private var navigationMap
		@SceneStorage("TopQuestionsView.Content.SelectedQuestionID")
		private var selectedQuestionID: Question.ID?
		
		var body: some View {
			List {
				ForEach(questions) { question in
					NavigationLink(
						destination: navigationMap.destinationForQuestion?(question),
						tag: question.id,
						selection: $selectedQuestionID) {
							QuestionRow(question: question)
						}
				}
				.onDelete(perform: deleteItems(atOffsets:))
				.onMove(perform: move(fromOffsets:toOffset:))
			}
			.listStyle(.plain)
			.navigationTitle("Top Questions")
			.toolbar {
				ToolbarItem(placement: .primaryAction) {
					EditButton()
				}
			}
		}
		
		func deleteItems(atOffsets offsets: IndexSet) {
			questions.remove(atOffsets: offsets)
		}
		
		func move(fromOffsets source: IndexSet, toOffset destination: Int) {
			questions.move(fromOffsets: source, toOffset: destination)
		}
	}
}

// MARK: - Previews
struct TopQuestionsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			NavigationView {
				Content(questions: .constant(TestData.questions))
			}
			.fullScreenPreviews()
			NavigationView {
				Content(questions: .constant(TestData.questions))
					.loading(true)
			}
		}
	}
}
