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
    }
    enum Mutation {
    }
    
    struct State {
        var documents: [QuestionJoinAnswer]
        var sections: [QuestionListSection]
    }
    
    init(
        documents: [QuestionJoinAnswer]
    ) {
        let sectionItems = documents
            .map(QuestionListItemCellReactor.init)
            .map(QuestionListSectionItem.listItem)
        let sections: [QuestionListSection] = [.list(sectionItems)]
        
        self.initialState = State(documents: documents, sections: sections)
    }
}

