//
//  CheckChoiceCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import ReactorKit

final class CheckChoiceCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case setChecked(Bool)
        case touchCell
    }
    enum Mutation {
        case setChecked(Bool)
    }
    
    struct State {
        let choice: CheckChoice
        var answers: String {
            self.choice.answers
        }
        var isChecked: Bool = false
    }
    
    init(choice: CheckChoice) {
        self.initialState = State(choice: choice)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .touchCell:
            return .just(Mutation.setChecked(!self.currentState.isChecked))
        case .setChecked(let isChecked):
            return .just(Mutation.setChecked(isChecked))
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

