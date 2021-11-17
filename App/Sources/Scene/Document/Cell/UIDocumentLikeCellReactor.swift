//
//  BuildUpLikeCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import ReactorKit

final class UIDocumentLikeCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
    }
    enum Mutation {
    }
    
    struct State {
        let likes: DocumentLike
        var isThumbUp: Bool {
            self.likes.isThumbUp
        }
        var thumbUpCnt: String? {
            NumberFormatter.toDecimal(self.likes.thumbUpCount)
        }
        var isLike: Bool {
            self.likes.isLike
        }
    }
    init(_ likes: DocumentLike) {
        self.initialState = State(likes: likes)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}

