//
//  QuestionFilterMenu.swift
//  App
//
//  Created by tyler on 2021/11/16.
//

import Foundation

enum QuestionFilterMenu: CaseIterable {
    case all
    case correct
    case incorrect
    
    var title: String {
        switch self {
        case .all:
            return "전체"
        case .correct:
            return "정답"
        case .incorrect:
            return "오답"
        }
    }
    
    static func find(title: String) -> QuestionFilterMenu? {
        return QuestionFilterMenu.allCases.first { $0.title == title }
    }
}
