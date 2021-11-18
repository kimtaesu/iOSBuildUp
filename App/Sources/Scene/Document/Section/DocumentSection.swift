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
    case tag(DocumentSection.Item)
}

extension DocumentSection: SectionModelType {
    public typealias Item = DocumentSectionItem

    var items: [Item] {
      switch self {
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
    case question(DocumentAttrQuestion)
    case tags([String])
    case checkChioce(UIDocumentAnswerCellReactor)
}
