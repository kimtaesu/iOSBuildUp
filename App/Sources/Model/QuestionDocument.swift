//
//  QuestionChioce.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation

struct QuestionDocument: Equatable {
    let docId: String
    let question: AttributeQuestion
    let chioces: [CheckChoice]
    let tags: [DocumentTag]
}

extension QuestionDocument {
    init(document: [String: Any]) {
        docId = ""
        question = .init(question: "")
        chioces = []
        tags = []
    }
}
