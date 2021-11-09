//
//  MainTabIndex.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import Foundation
import UIKit

enum MainTabItem: Int {
    case home = 0
    case search = 1
    case bookmark = 2
    case menu = 3
}

extension MainTabItem {
    
    var tag: Int {
        return self.rawValue
    }
    
    var title: String {
        switch self {
        case .home:
            return "홈"
        case .search:
            return "검색"
        case .bookmark:
            return "북마크"
        case .menu:
            return "더보기"
        }
    }
    
    var icon: UIImage {
        switch self {
        case .home:
            return Asset.tabHome.image
        case .search:
            return Asset.tabSearch.image
        case .bookmark:
            return Asset.tabBookmark.image
        case .menu:
            return Asset.tabMenu.image
        }
    }
    
    var tabItem: UITabBarItem {
        return .init(title: self.title, image: self.icon, tag: self.tag)
    }
}
