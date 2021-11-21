//
//  AuthDropDownItem.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import UIKit

enum AuthDropDownItem: CaseIterable {
    case google
    case logout
    
    
    var title: String {
        switch self {
        case .google:
            return "Google 로그인"
        case .logout:
            return "로그아웃"
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .google:
            return Asset.google.image
        case .logout:
            return Asset.logout.image
        }
    }
    
    static let signInItems: [AuthDropDownItem] = [.google]
    
    static func create(title: String) -> AuthDropDownItem? {
        return Self.allCases.first { $0.title == title }
    }
}
