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
        case setCurrentPage(Int)
        case listenQuestions
        case tapSubmit
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setQuestionPagination(QuestionPagination)
        case setCorrect(Bool)
        case setCurrentPage(Int)
    }
    
    struct State {
        var toast: String?
        
        let subject: DocumentSubject
        var sections: [DocumentPaginationSection] = []
        var documents: [QuestionJoinAnswer] = []
        
        var isLoading: Bool = false
        var currentPage: Int = 0
    }
    
    private let firestoreRepository: FirestoreRepository
    
    init(subject: DocumentSubject, repository: FirestoreRepository) {
        self.firestoreRepository = repository
        self.initialState = State(subject: subject)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCurrentPage(let page):
            return .just(.setCurrentPage(page))
        case .listenQuestions:
            return self.firestoreRepository.listenQuestionPagination(subject: self.currentState.subject.subject)
                .map(Mutation.setQuestionPagination)
        case .tapSubmit:
            guard let item = self.currentState.sections[safe: 0]?.items[self.currentState.currentPage] else { return .empty() }
            switch item {
            case .document(let reactor):
                guard let currentAnswer = reactor.currentState.selcetedAnswer else { return .empty() }
                return self.firestoreRepository.answer(docId: reactor.currentState.data.docId, choice: currentAnswer)
                    .map(Mutation.setCorrect)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.toast = nil
        switch mutation {
        case .setCurrentPage(let page):
            state.currentPage = page
            return state
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        case .setQuestionPagination(let pagination):
            state.documents = pagination.questionAnswers
            state.currentPage = pagination.answerCount
            state.sections = self.makeSections(pagination: pagination)
        case .setCorrect(let isCorrect):
            if isCorrect {
                state.toast = "정답입니다."
            } else {
                state.toast = "오답입니다."
            }
        }
        return state
    }
}

extension UIDocumentViewReactor {
    func makeSections(pagination: QuestionPagination) -> [DocumentPaginationSection] {
        let sectionItems = pagination.questionAnswers
            .map { UIDocumentCellReactor(data: $0, repository: self.firestoreRepository) }
            .map(DocumentPaginationSection.Item.document)
        return [.documents(sectionItems)]
    }
    
    func createDocumentListReactor() -> UIQuestionListViewReactor {
        return .init(documents: self.currentState.documents)
    }
}

extension UIDocumentViewReactor.State {
    var navigationTitle: String {
        guard self.totalCount > 0 else { return "" }
        let page = "(\(self.currentPage + 1)/\(self.totalCount))"
        return self.subject.subject + " " + page
    }
    var totalCount: Int {
        self.documents.count
    }
    var currentDocument: QuestionJoinAnswer? {
        self.documents[safe: self.currentPage]
    }
}
