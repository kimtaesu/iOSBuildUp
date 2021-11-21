//
//  QuestionListItemCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation


import ReactorKit

final class QuestionListItemCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
    }
    enum Mutation {
    }
    
    struct State {
        let doc: QuestionJoinAnswer
        var answerType: AnswerType {
            if let answer = self.doc.answer {
                return answer.isCorrect ? AnswerType.correct : AnswerType.wrong
            }
            return .notYet
        }
    }
    
    init(doc: QuestionJoinAnswer) {
        self.initialState = State(doc: doc)
    }
}
