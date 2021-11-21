//
//  MainMoreDropdown.swift
//  App
//
//  Created by tyler on 2021/11/19.
//

import Foundation

import UIKit
import DropDown

enum MainMoreDropDownMenu: CaseIterable {
    case contact
    case review
    case appVersion
    
    var title: String {
        switch self {
        case .review:
            return "리뷰쓰기"
        case .appVersion:
            return "앱 버전"
        case .contact:
            return "문의하기"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .review:
            return Asset.rateReview.image
        case .appVersion:
            return nil
        case .contact:
            return Asset.email.image
        }
    }
    
    static func firstItem(title: String) -> MainMoreDropDownMenu? {
        return Self.allCases.first { $0.title == title }
    }
}
