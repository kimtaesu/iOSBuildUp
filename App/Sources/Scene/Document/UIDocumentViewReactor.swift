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
        case setCurrentDocId(String)
        case setCurrentPage(Int)
        case listenQuestions
        case tapSubmit
    }
    
    enum Mutation {
        case setQuestionPagination(QuestionPagination)
        case setCorrect(Bool)
        case setCurrentPage(Int)
        case setToastMessage(String)
    }
    
    struct State {
        var toast: String?
        
        let subject: DocumentSubject
        var sections: [DocumentPaginationSection] = []
        var documents: [QuestionJoinAnswer] = []
        
        var isCorrect: Bool?
        
        var currentPage: Int?
    }
    
    private let firestoreRepository: FirestoreRepository
    
    init(subject: DocumentSubject, repository: FirestoreRepository) {
        self.firestoreRepository = repository
        self.initialState = State(subject: subject)
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setCurrentDocId(let docId):
            let foundPage = self.currentState.documents.firstIndex { $0.docId == docId }
            guard let foundPage = foundPage else { return .empty() }
            return .just(.setCurrentPage(foundPage))
        case .setCurrentPage(let page):
            return .just(.setCurrentPage(page))
        case .listenQuestions:
            return self.firestoreRepository.listenQuestionPagination(subject: self.currentState.subject.subject)
                .map(Mutation.setQuestionPagination)
        case .tapSubmit:
            guard let currentPage = self.currentState.currentPage else { return .empty() }
            guard let item = self.currentState.sections[safe: 0]?.items[safe: currentPage] else { return .empty() }
            switch item {
            case .document(let reactor):
                guard let currentAnswer = reactor.currentState.selcetedAnswer else { return .just(.setToastMessage("선택된 답이 없습니다.")) }
                let subject = self.currentState.subject.subject
                return self.firestoreRepository.answer(subject: subject, docId: reactor.currentState.data.docId, choice: currentAnswer)
                    .map(Mutation.setCorrect)
            }
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        state.toast = nil
        switch mutation {
        case .setToastMessage(let toast):
            state.toast = toast
            return state
        case .setCurrentPage(let page):
            state.currentPage = 0
            return state
        case .setQuestionPagination(let pagination):
            state.documents = pagination.questionAnswers
            state.currentPage = 0
            state.sections = self.makeSections(pagination: pagination)
        case .setCorrect(let isCorrect):
            state.isCorrect = isCorrect
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
        guard let currentPage = self.currentPage else { return "" }
        let page = "(\(currentPage + 1)/\(self.totalCount))"
        return self.subject.subject + " " + page
    }
    var totalCount: Int {
        self.documents.count
    }
    var currentDocument: QuestionJoinAnswer? {
        guard let currentPage = self.currentPage else { return nil }
        return self.documents[safe: currentPage]
    }
}
