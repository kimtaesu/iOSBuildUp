//
//  QuestionListSection.swift
//  App
//
//  Created by tyler on 2021/11/15.
//
import RxDataSources

enum QuestionListSection {
    case list([QuestionListSection.Item])
}

extension QuestionListSection: SectionModelType {
    public typealias Item = QuestionListSectionItem

    var items: [Item] {
      switch self {
      case .list(let items):
          return items
      }
    }
    public init(original: QuestionListSection, items: [Item]) {
        switch original {
        case .list(let items):
            self = .list(items)
        }
    }
}

enum QuestionListSectionItem {
    case listItem(QuestionListItemCellReactor)
}
