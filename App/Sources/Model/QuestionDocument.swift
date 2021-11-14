//
//  QuestionChioce.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation

struct QuestionDocument: Codable, Equatable {
    let docId: String
    let question: AttributeQuestion
    let choices: [CheckChoice]
    let tags: [String]
}
