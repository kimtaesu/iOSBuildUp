//
//  MainViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import ReactorKit
import FirebaseAuth

final class MainViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case touchCell
        case listenSubjects
        case listenUserState
        
        case refresh
        case signIn(AuthCredential)
        case signOut
    }
    enum Mutation {
        case setSubjects([BuildUpSubject])
        case setRefreshing(Bool)
        case setUser(User?)
        case setSignInError(Error)
    }
    
    struct State {
        var isRefreshing: Bool = false
        var user: User?
        var sections: [MainViewSection] = []
        var signInError: Error?
        var subjects: [BuildUpSubject] = []
    }
    
    private let repository: FirestoreRepository
    
    init(repository: FirestoreRepository) {
        self.repository = repository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .touchCell:
            return .empty()
        case .listenSubjects:
            return self.repository.listenSubjects()
                .map(Mutation.setSubjects)
        case .listenUserState:
            return self.repository.userStateDidChange()
                .map(Mutation.setUser)
            
        case .refresh:
//            guard !self.currentState.isRefreshing else { return .empty() }
//            let startRefreshing: Observable<Mutation> = .just(.setRefreshing(true))
//            let endRefreshing: Observable<Mutation> = .just(.setRefreshing(false))
//            let fetchAllTags = self.repository.getAllSubjects()
//                .map(Mutation.setCardItems)
//                .catch { error in
//                    logger.error(error)
//                    // TODO: handle error
//                    return .empty()
//                }
//            return Observable.concat(startRefreshing, fetchAllTags, endRefreshing)
            return .empty()
            
        case .signOut:
            return self.repository.signOut()
                .map { Mutation.setUser(nil) }
                .catch { .just(.setSignInError($0))}
            
        case .signIn(let credential):
            return self.repository.signIn(credential)
                .map(Mutation.setUser)
                .catch { .just(.setSignInError($0))}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.signInError = nil
        switch mutation {
        case .setSubjects(let subjects):
            let sectionItems = subjects
                .map { SubjectCardCellReactor.init(item: $0, repository: self.repository) }
                .map(MainViewSectionItem.card)
            state.sections = [MainViewSection.cards(sectionItems)]
            
        case .setSignInError(let error):
            state.signInError = error
        case .setUser(let user):
            state.user = user
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        }
        return state
    }
}


extension MainViewReactor.State {
    var userPhotoURL: URL? {
        return self.user?.photoURL
    }
    var authProvider: AuthProvider? {
        
        let providerID = self.user?.providerData.first?.providerID
        return AuthProvider.create(provider: providerID)
    }
    
    var isLoggined: Bool {
        return self.user != nil && self.user?.isAnonymous == false
    }
    
    var authDropDownDataSources: [String] {
        let items = self.isLoggined ? [.logout] : AuthDropDownItem.signInItems
        return items.map { $0.title }
    }
}