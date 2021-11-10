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
    }
    enum Mutation {
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
        return .empty()
    }
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}

