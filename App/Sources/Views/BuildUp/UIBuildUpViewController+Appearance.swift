//
//  UIBuildUpViewController+Appearance.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import DropDown

extension UIBuildUpViewController {
    
    func setUpSignInDropDownApprearance() {
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 46
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
