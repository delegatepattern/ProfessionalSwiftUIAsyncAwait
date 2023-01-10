//
//  LifehacksTests.swift
//  LifehacksTests
//
//  Created by Qasim Al Mahammedi on 1/10/23.
//

import XCTest
@testable import Lifehacks

class QuestionTests: XCTestCase {
    func testUpvote() {
        var question = makeQuestion()
        question.upvote()
        XCTAssertEqual(question.score, 1)
    }

    func testDownVote() {
        var question = makeQuestion()
        question.downvote()
        XCTAssertEqual(question.score, -1)
    }

    func testUnvote() {
        var question = makeQuestion()
        question.upvote()
        question.unvote()
        XCTAssertEqual(question.score, 0)
    }

    func testVotingOnce() {
        var question = makeQuestion()
        question.upvote()
        question.upvote()
        XCTAssertEqual(question.score, 1)
    }

    func testReversingVote() {
        var question = makeQuestion()
        question.upvote()
        question.downvote()
        XCTAssertEqual(question.score, -1)
    }
}

private extension QuestionTests {
    func makeQuestion() -> Question {
        let user = User(
            id: 0,
            reputation: 0,
            name: "",
            aboutMe: "",
            avatar: nil,
            profileImageURL: nil,
            userType: "")
        return Question(
            id: 0,
            viewCount: 0,
            answerCount: 0,
            title: "",
            body: "",
            isAnswered: true,
            creationDate: Date(),
            tags: [],
            owner: user,
            comments: [],
            answers: [],
            score: 0)
    }
}
