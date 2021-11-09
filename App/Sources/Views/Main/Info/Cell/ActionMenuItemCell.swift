//
//  SimpleTextCell.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit
import ManualLayout

struct ActionMenuItem {
    let isAccent: Bool
    let title: String
}

class ActionMenuItemCell: UICollectionViewCell {

    private struct Metrics {
        static let top: CGFloat = 8
        static let bottom: CGFloat = 8
    }
    
    private struct Font {
        static let title: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 18)
    }
    
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
        [self.titleLabel].forEach {
            self.contentView.addSubview($0)
        }
        self.backgroundColor = ColorName.appMenuActionMenuBG.color
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
    
    public func configCell(_ item: ActionMenuItem) {
        self.titleLabel.text = item.title
        
        if item.isAccent {
            self.titleLabel.textColor = ColorName.accent.color
        } else {
            self.titleLabel.textColor = .black
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.sizeToFit()
        self.titleLabel.center = self.contentView.center
    }
}

extension ActionMenuItemCell {
    class func size(_ width: CGFloat) -> CGSize {
        let height: CGFloat = Metrics.top
        + snap(Font.title.lineHeight)
        + Metrics.bottom
        return .init(width: width, height: height)
    }
}

