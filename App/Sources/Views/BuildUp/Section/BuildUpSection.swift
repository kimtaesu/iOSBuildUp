//
//  BuildUpSection.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import RxDataSources

enum BuildUpSection {
    case questions([BuildUpSection.Item])
    case answers([BuildUpSection.Item])
}

extension BuildUpSection: SectionModelType {
    public typealias Item = BuildUpSectionItem

    var items: [Item] {
      switch self {
      case .answers(let items):
          return items
      case .questions(let items):
          return items
      }
    }
    public init(original: BuildUpSection, items: [Item]) {
        switch original {
        case .answers(let items):
            self = .answers(items)
        case .questions(let item):
            self = .questions(item)
        }
    }
}

enum BuildUpSectionItem {
    case question(AttributeQuestion)
    case checkChioce(CheckChoiceCellReactor)
}
