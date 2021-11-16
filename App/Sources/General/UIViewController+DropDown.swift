//
//  UIViewController+DropDown.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import UIKit
import DropDown

protocol HasDropDownMenu: AnyObject {
    var dropDown: DropDown { get }
}

extension HasDropDownMenu where Self: UIViewController {
    func showDropDown(
        dataSources: [String],
        anchorView: UIView,
        iconColor: UIColor? = nil,
        configIcon: ((String) -> UIImage?)? = nil,
        didSelected: ((String) -> Void)? = nil
    ) {
        
        self.dropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        self.dropDown.customCellConfiguration = { index, item, cell -> Void in
            guard let cell = cell as? MyCell else { return }
            let icon = configIcon?(item)
            cell.logoImageView.image = icon
        }
        
        self.dropDown.dataSource = dataSources
        self.dropDown.anchorView = anchorView
        self.dropDown.bottomOffset = .init(x: 0, y: anchorView.height)
        self.dropDown.show()
        self.dropDown.selectionAction = { index, item in
            didSelected?(item)
            logger.debug("dropdown did selected: \(String(describing: item))")
        }
    }
}
