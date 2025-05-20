//
//  StorageManager.swift
//  iQuiz
//
//  Created by Cole Meier on 5/19/25.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    private init() {}

    private var fileURL: URL {
        let fm = FileManager.default
        let docs = fm.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("questions.json")
    }

    func saveQuizData(_ data: Data) throws {
        try data.write(to: fileURL, options: .atomic)
    }

    func loadQuizData() throws -> Data {
        return try Data(contentsOf: fileURL)
    }
}
