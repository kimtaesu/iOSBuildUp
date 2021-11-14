//
//  CheckChoiceCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import ReactorKit
import RxSwift
import RxCocoa

extension CheckChoice {
    enum Event {
        case setChecked(docId: String, CheckChoice)
    }
    static let event = PublishSubject<Event>()
}

final class BuildUpChoiceCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case touchCell
    }
    enum Mutation {
        case setChecked(Bool)
    }
    
    struct State {
        let docId: String
        let choice: CheckChoice
        var answers: String {
            self.choice.answer
        }
        var isChecked: Bool = false
    }
    
    init(docId: String, choice: CheckChoice) {
        self.initialState = State(docId: docId, choice: choice)
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let currentChoice: CheckChoice = self.currentState.choice
        let currentDocId: String = self.currentState.docId
        
        let fromCheckCoiceEvent: Observable<Mutation> = CheckChoice.event
            .filter { event in
                switch event {
                case let .setChecked(docId, _):
                    return currentDocId == docId
                }
            }
            .map { event in
                switch event {
                case let .setChecked(_, choice):
                    let isChecked = currentChoice == choice
                    return .setChecked(isChecked)
                }
        }
        return Observable.of(mutation, fromCheckCoiceEvent).merge()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .touchCell:
            return .just(Mutation.setChecked(!self.currentState.isChecked))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setChecked(let isChecked):
            state.isChecked = isChecked
        }
        return state
    }
}

