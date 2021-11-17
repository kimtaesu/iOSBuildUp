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
    }
    
    struct State {
        var sections: [DocumentSection] = []
    }
    
    private let repository: FirestoreRepository
    private let docId: String
    
    init(docId: String, repository: FirestoreRepository) {
        self.docId = docId
        self.repository = repository
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .listen:
            return self.repository.listenQuestion(docId: self.docId)
                .map(Mutation.setQuestion)
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setQuestion(let document):
            state.sections = self.makeSections(document: document)
        }
        return state
    }
}


extension UIDocumentCellReactor {
    func makeSections(document: QuestionJoinAnswer) -> [DocumentSection] {
        let question = document.question
        let answer = document.answer
        
        let choiceSectionItems = question.choices
            .map { choice in
                let isChecked = (choice.answer == answer?.answer) == true
                return UIDocumentAnswerCellReactor(docId: question.docId, choice: choice, isChecked: isChecked)
            }
            .map(DocumentSectionItem.checkChioce)
        
        return [
            .questions([.question(question.question)]),
            .tag(.tags(question.tags)),
            .answers(choiceSectionItems)
        ]
    }
}
