//
//  AppDelegate+Appearance.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import UIKit

extension AppDelegate {
    
    private struct Font {
        static let tabItemTitle: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 12)
    }
    
    func setUpAppearance() {
        self.setUpUITabBarItem()
    }
    
    private func setUpUITabBarItem() {
        UITabBar.appearance().unselectedItemTintColor = ColorName._888.color
        UITabBar.appearance().tintColor = ColorName.primary.color
        UITabBarItem.appearance().setTitleTextAttributes([.font : Font.tabItemTitle], for: .normal)
    }
}
