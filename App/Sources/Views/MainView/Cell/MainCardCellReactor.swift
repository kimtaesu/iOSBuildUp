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
        case getCompletedCount
    }
    enum Mutation {
        case setCompletedCount(MyQuestionCount)
    }
    
    struct State {
        let item: MainCardModel
        
        var completedCount: MyQuestionCount?
        
        var buildUpCount: String {
            return "\(self.completedCount?.answerCount)/\(self.completedCount?.totalCount)"
        }
    }
    
    private let repository: FirestoreRepository
    
    init(item: MainCardModel, repository: FirestoreRepository) {
        self.repository = repository
        self.initialState = State(item: item)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getCompletedCount:
            return self.repository.getMyCompletedCount(subject: self.currentState.item.collectionId)
                .map(Mutation.setCompletedCount)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setCompletedCount(let count):
            state.completedCount = count
        }
        return state
    }
}
