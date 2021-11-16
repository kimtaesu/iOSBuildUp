//
//  QuestionAnswer.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation
import SwiftDictionaryCoding

struct QuestionAnswer: Codable, CodingDictable, Equatable {
    let docId: String
    let timestamp: Date
    let answer: String
    let isCorrect: Bool
}

extension QuestionAnswer {
    init(docId: String, choice: CheckChoice) {
        self.docId = docId
        self.timestamp = Date()
        self.answer = choice.answer
        self.isCorrect = choice.isCorrect
    }
}

