//
//  AppDelegate+Appearance.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import UIKit
import DropDown

extension AppDelegate {
    
    private struct Font {
        static let tabItemTitle: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 12)
    }
    
    func setUpAppearance() {
        self.setUpDropDown()
        self.setUpNavigationBar()
    }
    
    private func setUpNavigationBar() {
        UINavigationBar.appearance().barTintColor = .white
    }
    
    private func setUpDropDown() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = .white
        appearance.selectionBackgroundColor = ColorName.authProviderSelectedBG.color.withAlphaComponent(0.2)
        appearance.cornerRadius = 4
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .black
        appearance.textFont = FontFamily.NotoSansCJKKR.medium.font(size: 14)
    }
    
}
