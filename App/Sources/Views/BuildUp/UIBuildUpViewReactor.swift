//
//  UIBuildUpViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import ReactorKit

final class UIBuildUpViewReactor: Reactor {
    
    struct Dependency {
        let buildUpService: BuildUpServiceType
    }
    
    let initialState: State
    
    enum Action {
        
    }
    
    enum Mutation {
    }
    
    struct State {
        
    }
    
    private let buildUpService: BuildUpServiceType
    
    init(dependency: Dependency) {
        self.buildUpService = dependency.buildUpService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}

