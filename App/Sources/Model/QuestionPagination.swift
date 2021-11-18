//
//  QuestionPagination.swift
//  App
//
//  Created by tyler on 2021/11/18.
//

import Foundation

struct QuestionPagination: Equatable {
    let questionAnswers: [QuestionJoinAnswer]
    let answerCount: Int
    var totalCount: Int {
        return self.questionAnswers.count
    }
}
