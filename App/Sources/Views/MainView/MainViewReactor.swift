//
//  MainViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import ReactorKit

final class MainViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case refresh
    }
    enum Mutation {
        case setRefreshing(Bool)
        case setCardItems([MainCardModel])
    }
    
    struct State {
        var isRefreshing: Bool = false
        var sections: [MainViewSection] = []
        var tags: [MainCardModel] = []
    }
    
    private let repository: FirestoreRepository
    
    init(repository: FirestoreRepository) {
        self.repository = repository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            guard !self.currentState.isRefreshing else { return .empty() }
            let startRefreshing: Observable<Mutation> = .just(.setRefreshing(true))
            let endRefreshing: Observable<Mutation> = .just(.setRefreshing(false))
            let fetchAllTags = self.repository.getAllSubjects()
                .map(Mutation.setCardItems)
                .catch { error in
                    logger.error(error)
                    return .empty()
                }
            
            return Observable.concat(startRefreshing, fetchAllTags, endRefreshing)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCardItems(let items):
            let cardSectionItems = items
                .map { MainCardCellReactor.init(item: $0, repository: self.repository) }
                .map(MainViewSectionItem.card)
            state.sections = [MainViewSection.cards(cardSectionItems)]
            
        case .setRefreshing(let isRefreshing):
            state.isRefreshing = isRefreshing
        }
        return state
    }
}

