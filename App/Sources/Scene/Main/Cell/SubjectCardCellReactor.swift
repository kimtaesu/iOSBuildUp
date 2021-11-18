//
//  MainCardCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import ReactorKit

final class SubjectCardCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case listenDocument
    }
    enum Mutation {
        case setDocuments(QuestionPagination)
    }
    
    struct State {
        let item: DocumentSubject
        var documents: QuestionPagination?
    }
    
    private let repository: FirestoreRepository
    
    init(item: DocumentSubject, repository: FirestoreRepository) {
        self.repository = repository
        self.initialState = State(item: item)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listenDocument:
            return self.repository.listenQuestionPagination(subject: self.currentState.item.subject)
                .map(Mutation.setDocuments)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setDocuments(let documnets):
            state.documents = documnets
        }
        return state
    }
}
