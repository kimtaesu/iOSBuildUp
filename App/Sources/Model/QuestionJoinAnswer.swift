//
//  QuestionJoinAnswer.swift
//  App
//
//  Created by tyler on 2021/11/18.
//

import Foundation

struct QuestionJoinAnswer: Equatable {
    let question: QuestionDocument
    let answer: QuestionAnswer?
    
    var docId: String {
        self.question.docId
    }
}
