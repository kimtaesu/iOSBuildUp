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
        let router: StrongRouter<AppRoute>
    }
    
    let initialState: State
    
    enum Action {
        case getUser
    }
    enum Mutation {
        case setUser(AppUser)
        case nextScreen
    }
    
    struct State {
        var user: AppUser?
    }
    
    private let authService: AuthServiceType
    private let router: StrongRouter<AppRoute>
    
    init(
        dependency: Dependency
    ) {
        self.authService = dependency.authService
        self.router = dependency.router
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getUser:
            let setUser = self.authService.getUserIfNeedAnonymous()
                .map(Mutation.setUser)
            return Observable.concat(setUser, Observable.just(Mutation.nextScreen))
            
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case  .setUser(let user):
            state.user = user
        case .nextScreen:
            // TODO: Test Case
            self.router.trigger(AppRoute.home)
        }
        return state
    }
}

