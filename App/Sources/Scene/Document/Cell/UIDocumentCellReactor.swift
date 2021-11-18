//
//  BuildUpDocumentCellReactor.swift
//  App
//
//  Created by tyler on 2021/11/17.
//

import ReactorKit

final class UIDocumentCellReactor: Reactor {
    
    let initialState: State
    
    enum Action {
        case listen
    }
    
    enum Mutation {
        case setQuestion(QuestionJoinAnswer)
        case setSelectedAnswer(CheckChoice)
    }
    
    struct State {
        var data: QuestionJoinAnswer
        var sections: [DocumentSection] = []
        var selcetedAnswer: CheckChoice?
    }
    
    private let repository: FirestoreRepository
    private let data: QuestionJoinAnswer
    
    init(data: QuestionJoinAnswer, repository: FirestoreRepository) {
        self.data = data
        self.repository = repository
        self.initialState = State(data: data)
        
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromCheckCoiceEvent: Observable<Mutation> = CheckChoice.event
            .filter { [weak self] event in
                guard let self = self else { return false }
                switch event {
                case let .setChecked(docId, _):
                    return self.data.question.docId == docId
                }
            }
            .map { event in
                switch event {
                case let .setChecked(_, choice):
                    return .setSelectedAnswer(choice)
                }
        }
        return Observable.of(mutation, fromCheckCoiceEvent).merge()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listen:
            return .just(.setQuestion(self.currentState.data))
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setSelectedAnswer(let answer):
            state.selcetedAnswer = answer
        case .setQuestion(let document):
            state.sections = self.makeSections(document: document)
        }
        return state
    }
}

extension UIDocumentCellReactor {
    func makeSections(document: QuestionJoinAnswer) -> [DocumentSection] {
        let serverQuestion = document.question
        let serverAnswer = document.answer
        
        let choiceSectionItems = serverQuestion.choices
            .map { choice in
                let isChecked = (choice.answer == serverAnswer?.answer) == true
                return UIDocumentAnswerCellReactor(docId: serverQuestion.docId, choice: choice, isChecked: isChecked)
            }
            .map(DocumentSectionItem.checkChioce)
        
        return [
            .questions([.question(serverQuestion.question)]),
            .tag(.tags(serverQuestion.tags)),
            .answers(choiceSectionItems)
        ]
    }
}
