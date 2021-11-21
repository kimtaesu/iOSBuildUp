//
//  AppDelegate+Appearance.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import UIKit
import DropDown
import TagListView

extension AppDelegate {
    
    private struct Font {
        static let tabItemTitle: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 12)
    }
    
    func setUpAppearance() {
        self.setUpDropDown()
        self.setUpNavigationBar()
        self.setUpTagList()
    }
    
    private func setUpNavigationBar() {
        UINavigationBar.appearance().barTintColor = .white
    }
    
    private func setUpDropDown() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = .white
        appearance.selectionBackgroundColor = ColorName.dropdownSelected.color.withAlphaComponent(0.2)
        appearance.cornerRadius = 4
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .black
        appearance.textFont = FontFamily.NotoSansCJKKR.medium.font(size: 14)
    }
    
    private func setUpTagList() {
        TagListView.appearance().paddingX = 5
        TagListView.appearance().paddingY = 5
        TagListView.appearance().marginX = 5
        TagListView.appearance().marginY = 5
        TagListView.appearance().cornerRadius = 8
        TagListView.appearance().textColor = .white
        TagListView.appearance().textFont = FontFamily.NotoSansCJKKR.medium.font(size: 14)
        TagListView.appearance().layer.masksToBounds = true
    }
}
