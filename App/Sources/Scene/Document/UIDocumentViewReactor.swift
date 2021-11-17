//
//  UIBuildUpViewReactor.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import ReactorKit
import FirebaseAuth

final class UIDocumentViewReactor: Reactor {
    let initialState: State
    
    enum Action {
        case listenQuestions
        case tapSubmit
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setQuestionPagination(QuestionPagination)
        case setChoiceSelected(CheckChoice)
        case setCorrect(Bool)
    }
    
    struct State {
        var sections: [DocumentPaginationSection] = []
        var isLoading: Bool = false
        var selectedChoice: CheckChoice?
        var isCorrect: Bool?
        var totalCount: Int = 0
        var currentPosition: Int = 0
    }
    
    private let firestoreRepository: FirestoreRepository
    private let subject: String?
    
    init(subject: String?, repository: FirestoreRepository) {
        self.subject = subject
        self.firestoreRepository = repository
        self.initialState = State()
    }
    
//    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
//        let fromCheckCoiceEvent: Observable<Mutation> = CheckChoice.event
//            .filter { [weak self] event in
//                switch event {
//                case let .setChecked(docId, _):
//                    return self?.docId == docId
//                }
//            }
//            .flatMap { event -> Observable<Mutation> in
//                switch event {
//                case let .setChecked(_, choice):
//                    return .just(.setChoiceSelected(choice))
//                }
//        }
//        return Observable.of(mutation, fromCheckCoiceEvent).merge()
//    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listenQuestions:
            return self.firestoreRepository.listenQuestionPagination(subject: self.subject)
                .map(Mutation.setQuestionPagination)
        case .tapSubmit:
//            guard let selectedChoice = self.currentState.selectedChoice else { return .empty() }
//            guard let question = self.currentState.question else { return .empty() }
//
//            let isCorrect = selectedChoice.isCorrect
//            return self.firestoreRepository.answer(docId: question.question.docId, choice: selectedChoice)
//                .map { _ in Mutation.setCorrect(isCorrect) }
            return .empty()
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.isCorrect = nil
        switch mutation {
        case .setChoiceSelected(let selected):
            state.selectedChoice = selected
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setQuestionPagination(let pagination):
            state.totalCount = pagination.totalCount
            state.currentPosition = pagination.nextPosition
            state.sections = self.makeSections(pagination: pagination)
        case .setCorrect(let isCorrect):
            state.isCorrect = isCorrect
        }
        return state
    }
}

extension UIDocumentViewReactor {
    func makeSections(pagination: QuestionPagination) -> [DocumentPaginationSection] {
        let sectionItems = pagination.docIds
            .map { UIDocumentCellReactor(docId: $0, repository: self.firestoreRepository) }
            .map(DocumentPaginationSection.Item.document)
        return [.documents(sectionItems)]
    }
}
