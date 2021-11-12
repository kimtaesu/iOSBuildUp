//
//  QuestionChioce.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import Foundation

struct QuestionDocument: Equatable {
    let question: AttributeQuestion
    let chioces: [CheckChoice]
    let tags: [DocumentTag]
    let likes: DocumentLike
}
