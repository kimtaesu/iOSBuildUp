//
//  AppMenuSection.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import RxDataSources

enum AppMenuSection {
    case profile(AppMenuSectionItem)
    case sectionHeader(header: String, items: [AppMenuSectionItem])
    case actionMenu([AppMenuSectionItem])
}

public enum AppMenuSectionItem {
    case profile
    case version
    case github
    case review
    case contact
    case logout
}


extension AppMenuSection: SectionModelType {
    public typealias Item = AppMenuSectionItem

    var items: [Item] {
      switch self {
      case .actionMenu(let items):
          return items
      case .profile(let item):
          return [item]
      case let .sectionHeader(_, items):
          return items
      }
    }
    public init(original: AppMenuSection, items: [Item]) {
        switch original {
        case .actionMenu(let items):
            self = .actionMenu(items)
        case .profile(let item):
            self = .profile(item)
        case .sectionHeader(let header, let items):
            self = .sectionHeader(header: header, items: items)
        }
    }
}
