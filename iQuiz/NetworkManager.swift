//
//  NetworkManager.swift
//  iQuiz
//
//  Created by Cole Meier on 5/14/25.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    func fetchQuizzes(from urlString: String,
                      completion: @escaping (Result<[Quiz], Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL)); return
        }

        URLSession.shared.dataTask(with: url) { data, _, err in
            if let err = err {
                completion(.failure(err)); return
            }
            guard let data = data else {
                completion(.failure(NetworkError.noData)); return
            }

            do {
                let raws = try JSONDecoder().decode([RawQuiz].self, from: data)
                let quizzes = raws.map { $0.toQuiz() }

                do {
                    try StorageManager.shared.saveQuizData(data)
                } catch {
                    print("⚠️ Failed to save quizzes locally: \(error)")
                }

                completion(.success(quizzes))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    enum NetworkError: LocalizedError {
        case invalidURL, noData
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "The URL is invalid."
            case .noData:     return "No data received from server."
            }
        }
    }
}

private struct RawQuiz: Decodable {
    let title: String
    let desc: String
    let questions: [RawQuestion]

    func toQuiz() -> Quiz {
        let iconName: String
        switch title.lowercased() {
        case "mathematics":         iconName = "function"
        case "science":             iconName = "atom"
        case "marvel super heroes": iconName = "person.3.fill"
        default:                    iconName = "book"
        }
        let icon = UIImage(systemName: iconName)!
        let qs = questions.map { $0.toQuestion() }
        return Quiz(title: title, description: desc, icon: icon, questions: qs)
    }
}

private struct RawQuestion: Decodable {
    let text: String
    let answers: [String]
    let answer: String

    func toQuestion() -> Question {
        let rawIdx = (Int(answer) ?? 1) - 1
        let idx = min(max(rawIdx, 0), answers.count - 1)
        return Question(text: text, options: answers, correctIndex: idx)
    }
}

extension NetworkManager {
    func loadCachedQuizzes() -> [Quiz]? {
        guard let data = try? StorageManager.shared.loadQuizData() else {
            return nil
        }
        guard let raws = try? JSONDecoder().decode([RawQuiz].self, from: data) else {
            return nil
        }
        return raws.map { $0.toQuiz() }
    }
}
