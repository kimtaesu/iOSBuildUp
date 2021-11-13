//
//  MainCardCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import ReactorKit

final class MainCardCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
    }
    enum Mutation {
    }
    
    struct State {
        let item: MainCardModel
        
        var buildUpCount: String {
            return "0/0"
        }
    }
    init(item: MainCardModel) {
        self.initialState = State(item: item)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
