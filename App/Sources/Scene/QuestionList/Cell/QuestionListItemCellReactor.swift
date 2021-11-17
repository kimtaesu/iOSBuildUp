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
        case observeAnswer
    }
    enum Mutation {
        case setAnswer(QuestionAnswer)
    }
    
    struct State {
        let doc: QuestionDocument
        
        var answer: QuestionAnswer?
    }
    
    private let repository: FirestoreRepository
    private let subject: String
    private let docId: String
    
    init(subject: String, doc: QuestionDocument, repository: FirestoreRepository) {
        self.subject = subject
        self.docId = doc.docId
        self.repository = repository
        self.initialState = State(doc: doc)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .observeAnswer:
            return .empty()
//            return self.repository.listenAnswer(subject: self.subject, docId: self.docId)
//                .map(Mutation.setAnswer)
//                .catch { error in return .empty() }
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setAnswer(let answer):
            state.answer = answer
        }
        return state
    }
}

