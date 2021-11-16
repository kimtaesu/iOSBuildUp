//
//  UIBuildUpViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import ReactorKit
import FirebaseAuth

final class UIBuildUpViewReactor: Reactor {
    
    struct Dependency {
        let subject: String
        let docId: String?
        let firestoreRepository: FirestoreRepository
    }
    
    let initialState: State
    
    enum Action {
        case listenQuestion
        case tapNext
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setQuestion(QuestionDocument)
        case setChoiceSelected(CheckChoice)
        case setNext(Bool)
    }
    
    struct State {
        var question: QuestionDocument?
        var isLoading: Bool = false
        var selectedChoice: CheckChoice?
        var isNext: Bool = false
        var sections: [BuildUpSection] = []
    }
    
    private let firestoreRepository: FirestoreRepository
    let subject: String
    let docId: String?
    
    init(dependency: Dependency) {
        self.subject = dependency.subject
        self.docId = dependency.docId
        self.firestoreRepository = dependency.firestoreRepository
        self.initialState = State()
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromCheckCoiceEvent: Observable<Mutation> = CheckChoice.event
            .filter { [weak self] event in
                switch event {
                case let .setChecked(docId, _):
                    return self?.docId == docId
                }
            }
            .flatMap { event -> Observable<Mutation> in
                switch event {
                case let .setChecked(_, choice):
                    return .just(.setChoiceSelected(choice))
                }
        }
        return Observable.of(mutation, fromCheckCoiceEvent).merge()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listenQuestion:
            if let docId = self.docId {
                return self.firestoreRepository.listenQuestion(subject: self.subject, docId: docId)
                    .map(Mutation.setQuestion)
            } else {
                return self.firestoreRepository.listenQuestion(subject: self.subject)
                    .map(Mutation.setQuestion)
            }
        case .tapNext:
            guard let selectedChoice = self.currentState.selectedChoice else { return .empty() }
            guard let question = self.currentState.question else { return .empty() }

            return self.firestoreRepository.answer(docId: question.docId, choice: selectedChoice)
                .map { _ in Mutation.setNext(true) }
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isNext = false
        
        switch mutation {
        case .setChoiceSelected(let selected):
            state.selectedChoice = selected
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setQuestion(let question):
            state.question = question
            state.sections = self.makeSections(question: question)
        case .setNext(let isNext):
            state.isNext = isNext
        }
        return state
    }
}

extension UIBuildUpViewReactor {
    func makeSections(question: QuestionDocument) -> [BuildUpSection] {
        let choiceSectionItems = question.choices
            .map { BuildUpChoiceCellReactor(docId: question.docId, choice: $0) }
            .map(BuildUpSectionItem.checkChioce)
        
        return [
            .questions([.question(question.question)]),
            .tag(.tags(question.tags)),
            .answers(choiceSectionItems)
        ]
    }
}
