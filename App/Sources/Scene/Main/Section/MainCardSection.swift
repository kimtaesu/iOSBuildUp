//
//  MainSection.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import RxDataSources

enum MainViewSection {
    case cards([MainViewSectionItem])
}

extension MainViewSection: SectionModelType {
    public typealias Item = MainViewSectionItem

    var items: [Item] {
      switch self {
      case .cards(let items):
          return items
      }
    }
    public init(original: MainViewSection, items: [Item]) {
        switch original {
        case .cards(let items):
            self = .cards(items)
        }
    }
}

enum MainViewSectionItem {
    case card(SubjectCardCellReactor)
}
