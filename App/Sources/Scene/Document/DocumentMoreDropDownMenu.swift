//
//  BuilUpMoreDropDownMenu.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import UIKit
import DropDown

enum DocumentMoreDropDownMenu: CaseIterable {
    case allQuestions
    case contact
    
    var title: String {
        switch self {
        case .allQuestions:
            return "모든 문제"
        case .contact:
            return "오탈자 및 문의하기"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .contact:
            return Asset.email.image
        case .allQuestions:
            return Asset.dropdownMenuAll.image
        }
    }
    
    static func firstItem(title: String) -> DocumentMoreDropDownMenu? {
        return Self.allCases.first { $0.title == title }
    }
}
