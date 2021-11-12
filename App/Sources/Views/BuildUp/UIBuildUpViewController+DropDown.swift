//
//  UIBuildUpViewController+Appearance.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import DropDown


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
    
    static var signInItems: [AuthDropDownItem] = [.google]
    static var signOutItems: [AuthDropDownItem] = [.logout]
    
    static func create(title: String) -> AuthDropDownItem? {
        return Self.allCases.first { $0.title == title }
    }
}


extension UIBuildUpViewController {
    private func setUpSignInDropDownApprearance() {
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
    
    
    public func showSignProviderDropDown(
        anchorView: UIView,
        dataSources: [AuthDropDownItem],
        didSelected: @escaping (AuthDropDownItem?) -> Void
    ) {
        self.setUpSignInDropDownApprearance()

        self.dropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        self.dropDown.customCellConfiguration = { index, item, cell -> Void in
            guard let cell = cell as? MyCell else { return }
            cell.logoImageView.image = AuthDropDownItem.create(title: item)?.icon
        }
        
        self.dropDown.dataSource = dataSources.map { $0.title }
        self.dropDown.anchorView = anchorView
        self.dropDown.bottomOffset = .init(x: 0, y: anchorView.height)
        self.dropDown.show()
        self.dropDown.selectionAction = { index, item in
            let selected = AuthDropDownItem.create(title: item)
            didSelected(selected)
            logger.debug("did selected: \(String(describing: selected))")
        }
    }
}
