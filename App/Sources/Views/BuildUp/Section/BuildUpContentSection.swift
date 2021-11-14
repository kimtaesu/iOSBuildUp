//
//  BuildUpContentSection.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import RxDataSources

enum BuildUpContentSection {
    case content([BuildUpContentSection.Item])
}

extension BuildUpContentSection: SectionModelType {
    public typealias Item = BuildUpContentSectionItem

    var items: [Item] {
      switch self {
      case .content(let items):
          return items
      }
    }
    
    public init(original: BuildUpContentSection, items: [Item]) {
        switch original {
        case .content(let item):
            self = .content(item)
        }
    }
}

enum BuildUpContentSectionItem {
    case content(BuildUpContentCellReactor)
}
