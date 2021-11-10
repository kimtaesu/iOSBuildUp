//
//  QuestionChioce.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation


struct AttributeQuestion: Equatable {
    let question: String
}

struct QuestionDocument: Equatable {
    let question: AttributeQuestion
    let chioces: [CheckChoice]
}

struct CheckChoice: Equatable {
    let answers: String
    let isCorrect: Bool
}
