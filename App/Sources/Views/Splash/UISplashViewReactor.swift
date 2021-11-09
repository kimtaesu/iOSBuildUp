//
//  UISplashViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import ReactorKit
import XCoordinator

final class UISplashViewReactor: Reactor {
    
    struct Dependency {
        let authService: AuthServiceType
    }
    
    let initialState: State
    
    enum Action {
        case getUser
    }
    enum Mutation {
        case setUser(AppUser)
    }
    
    struct State {
        var user: AppUser?
    }
    
    private let authService: AuthServiceType
    
    init(
        authService: AuthServiceType
    ) {
        self.authService = authService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getUser:
            let setUser = self.authService.getUserIfNeedAnonymous()
                .map(Mutation.setUser)
            return Observable.concat(setUser)
            
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case  .setUser(let user):
            state.user = user
        }
        return state
    }
}

