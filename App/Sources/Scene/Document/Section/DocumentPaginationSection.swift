//
//  BuildUpSection.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import RxDataSources

enum DocumentPaginationSection {
    case documents([DocumentPaginationSection.Item])
}

extension DocumentPaginationSection: SectionModelType {
    public typealias Item = DocumentPaginationSectionItem

    var items: [Item] {
      switch self {
      case .documents(let items):
          return items
      }
    }
    public init(original: DocumentPaginationSection, items: [Item]) {
        switch original {
        case .documents(let items):
            self = .documents(items)
        }
    }
}

enum DocumentPaginationSectionItem {
    case document(UIDocumentCellReactor)
}
