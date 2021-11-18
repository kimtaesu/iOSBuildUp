//
//  QuestionChioce.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation

struct QuestionDocument: Codable, Equatable, CodingDictable, HasDocumentId {
    let docId: String
    let question: DocumentAttrQuestion
    let choices: [CheckChoice]
    let tags: [String]
}
