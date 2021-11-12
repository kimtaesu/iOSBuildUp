//
//  AuthProvider.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import UIKit

enum AuthProvider: String, CaseIterable {
    case google
}

extension AuthProvider {
    static func create(title: String) -> AuthProvider? {
        return Self.allCases.first { $0.title == title }
    }
    
    static func create(provider: String?) -> AuthProvider? {
        guard let provider = provider,
              provider.isNotEmpty else { return nil} 
        return Self.allCases.first { $0.provider == provider }
    }
    
    /// Firebase Auth supported identity providers and other methods of authentication
    var provider: String {
        switch self {
        case .google:
            return "google.com"
        }
    }
    var title: String {
        switch self {
        case .google:
            return "Google"
        }
    }
    var icon: UIImage? {
        switch self {
        case .google:
            return Asset.google.image
        }
    }
}
