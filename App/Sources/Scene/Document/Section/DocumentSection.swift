//
//  BuildUpSection.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import RxDataSources

enum DocumentSection {
    case questions([DocumentSection.Item])
    case answers([DocumentSection.Item])
    case like(DocumentSection.Item)
    case tag(DocumentSection.Item)
}

extension DocumentSection: SectionModelType {
    public typealias Item = DocumentSectionItem

    var items: [Item] {
      switch self {
      case .like(let item):
          return [item]
      case .tag(let item):
          return [item]
      case .answers(let items):
          return items
      case .questions(let items):
          return items
      }
    }
    public init(original: DocumentSection, items: [Item]) {
        switch original {
        case .like(let item):
            self = .like(item)
        case .tag(let item):
            self = .tag(item)
        case .answers(let items):
            self = .answers(items)
        case .questions(let item):
            self = .questions(item)
        }
    }
}

enum DocumentSectionItem {
    case question(AttributeQuestion)
    case tags([String])
    case like(UIDocumentLikeCellReactor)
    case checkChioce(UIDocumentAnswerCellReactor)
}
