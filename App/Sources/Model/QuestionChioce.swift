//
//  QuestionChioce.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation


struct Tag: Equatable {
    let id: String
    let title: String
}

struct AttributeQuestion: Equatable {
    let question: String
}

struct QuestionDocument: Equatable {
    let question: AttributeQuestion
    let chioces: [CheckChoice]
    let tags: [Tag]
}

struct CheckChoice: Equatable {
    let answers: String
    let isCorrect: Bool
}
