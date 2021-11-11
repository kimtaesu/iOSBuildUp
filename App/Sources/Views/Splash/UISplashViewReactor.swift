//
//  UISplashViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import ReactorKit
import FirebaseAuth
import XCoordinator

final class UISplashViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case getUser
    }
    enum Mutation {
        case setUser(User)
        case setError(Error)
    }
    
    struct State {
        var error: Error?
        var user: User?
        var isNextScreen: Bool = false
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
                .catch { .just(Mutation.setError($0)) }
            
            return Observable.concat(setUser)
            
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isNextScreen = false
        
        switch mutation {
        case .setError(let error):
            logger.debug("set user error: \(error)")
            state.isNextScreen = true
            state.error = error
        case  .setUser(let user):
            logger.debug("set user: \(user)")
            state.isNextScreen = true
            state.user = user
        }
        return state
    }
}

