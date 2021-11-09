//
//  AppInfoViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import ReactorKit

final class AppMenuViewReactor: Reactor {
  
    let initialState: State
  
    enum Action {
    }
    
    enum Mutation {
    }
  
    struct State {
       var sections: [AppMenuSection]
    }
    
    init() {
        let sections: [AppMenuSection] = [
            .profile(.profile),
            .sectionHeader(header: "앱 정보", items: [
                .version,
                .github
            ]),
            .actionMenu([
                .review,
                .contact
            ]),
            .actionMenu([
                .logout
            ])
        ]
        self.initialState = State(sections: sections)
        _ = self.state
    }
  
    func mutate(action: Action) -> Observable<Mutation> {
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}

