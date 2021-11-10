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
        case nextQuestion
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setDocument(QuestionDocument)
    }
    
    struct State {
        var isLoading: Bool = false
        var document: QuestionDocument?
        var question: String?
        var choices: [CheckChoice]?
        
        var sections: [BuildUpSection] = []
        
    }
    
    private let buildUpService: BuildUpServiceType
    
    init(dependency: Dependency) {
        self.buildUpService = dependency.buildUpService
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .nextQuestion:
            guard !self.currentState.isLoading else { return .empty() }
            let startLoading: Observable<Mutation> = .just(.setLoading(true))
            let nextQuestion: Observable<Mutation> = self.buildUpService.nextQuestion()
                .map(Mutation.setDocument)
            let endLoading: Observable<Mutation> = .just(.setLoading(false))
            return Observable.concat(startLoading, nextQuestion, endLoading)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setDocument(let document):
            state.document = document
            state.sections = self.makeSections(doc: document)
        }
        return state
    }
}


extension UIBuildUpViewReactor {
    func makeSections(doc: QuestionDocument) -> [BuildUpSection] {
        
        let choiceSectionItems = doc.chioces
            .map(CheckChoiceCellReactor.init)
            .map(BuildUpSectionItem.checkChioce)
        
        return [
            .questions([.question(doc.question)]),
            .answers(choiceSectionItems)
        ]
    }
}
