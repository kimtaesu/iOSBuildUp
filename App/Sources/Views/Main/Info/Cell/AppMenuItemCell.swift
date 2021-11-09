//
//  AppMenuItemCell.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import Foundation
import UIKit
import ManualLayout

struct AppMenuItem {
    let iconName: String
    let title: String
}

class AppMenuItemCell: UICollectionViewCell {

    private struct Metrics {
        static let iconSize: CGFloat = 20
        static let titleLeft: CGFloat = 8
    }
    
    private struct Font {
        static let title: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 16)
    }
    
    private let iconView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.title
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        [self.iconView, self.titleLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    public func configCell(_ item: AppMenuItem) {
        self.iconView.image = UIImage(named: item.iconName)
        self.titleLabel.text = item.title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.iconView.sizeToFit()
        self.iconView.left = self.contentView.bounds.left
        self.iconView.size = .init(width: Metrics.iconSize, height: Metrics.iconSize)
        self.iconView.centerY = self.contentView.bounds.centerY
        
        self.titleLabel.sizeToFit()
        self.titleLabel.left = self.iconView.right + Metrics.titleLeft
        self.titleLabel.width = min(
            self.titleLabel.width,
            self.contentView.width - self.titleLabel.left
        )
    }
}

extension AppMenuItemCell {
    class func size(_ width: CGFloat) -> CGSize {
        let height: CGFloat = max(Metrics.iconSize, snap(Font.title.lineHeight))
        return .init(width: width, height: height)
    }
}

