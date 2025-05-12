//
//  QuizSession.swift
//  iQuiz
//
//  Created by Cole Meier on 5/12/25.
//

class QuizSession {
    let quiz: Quiz
    private(set) var current = 0
    private(set) var correctCount = 0
    init(quiz: Quiz) { self.quiz = quiz }
    var currentQuestion: Question { quiz.questions[current] }
    var isLastQuestion: Bool { current == quiz.questions.count - 1 }
    func submitAnswer(_ index: Int) {
        if index == currentQuestion.correctIndex { correctCount += 1 }
    }
    func advance() { current += 1 }
    func reset() { current = 0; correctCount = 0 }
}
