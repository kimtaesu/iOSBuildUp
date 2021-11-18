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
    }
    
    init(doc: QuestionJoinAnswer) {
        self.initialState = State(doc: doc)
    }
}

