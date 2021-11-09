//
//  UISignViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import Foundation

import ReactorKit

final class UISignViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
    }
    enum Mutation {
    }
    
    struct State {
        
    }
    
    init() {
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}

