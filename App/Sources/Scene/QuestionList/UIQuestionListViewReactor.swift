//
//  DocListViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import ReactorKit

final class UIQuestionListViewReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case listenQuestions
    }
    enum Mutation {
        case setQuestions([QuestionDocument])
        case setLoading(Bool)
    }
    
    struct State {
        var isLoading: Bool = false
        var questionDocuments: [QuestionDocument] = []
        var sections: [QuestionListSection] = []
    }
    
    private let repository: FirestoreRepository
    private let subject: String
    
    init(
        subject: String,
        repository: FirestoreRepository
    ) {
        self.subject = subject
        self.repository = repository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listenQuestions:
            return .empty()
//            let listenQuestions: Observable<Mutation> = self.repository.listenQuestions(subject: self.subject)
//                .map(Mutation.setQuestions)
//            return Observable.concat(listenQuestions)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setQuestions(let questions):
            state.questionDocuments = questions
            state.isLoading = false
            state.sections = self.makeSections(questions: questions)
        }
        return state
    }
}


extension UIQuestionListViewReactor {
    func makeSections(questions: [QuestionDocument]) -> [QuestionListSection] {
        let sectionItems = questions
            .map { QuestionListItemCellReactor.init(subject: self.subject, doc: $0, repository: self.repository) }
            .map(QuestionListSectionItem.listItem)
        
        return [
            .list(sectionItems)
        ]
    }
}
