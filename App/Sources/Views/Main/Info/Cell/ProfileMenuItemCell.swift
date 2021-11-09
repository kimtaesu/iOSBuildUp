//
//  ProfileMenuItemCell.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit
import ManualLayout

struct ProfileMenuItem {
    let userName: String?
    let email: String?
}

class ProfileMenuItemCell: UICollectionViewCell {

    private struct Metrics {
        static let emailTop: CGFloat = 8
    }
    
    private struct Font {
        static let userName: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 16)
        static let email: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 14)
    }
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.userName
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = Font.email
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        [self.userNameLabel, self.emailLabel].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    public func configCell(_ item: ProfileMenuItem) {
        self.userNameLabel.text = item.userName
        self.emailLabel.text = item.email
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.userNameLabel.sizeToFit()
        self.userNameLabel.centerX = self.contentView.bounds.centerX
        self.userNameLabel.width = min(self.userNameLabel.width, self.contentView.bounds.width)
        self.userNameLabel.top = self.contentView.bounds.top
        
        self.emailLabel.sizeToFit()
        self.emailLabel.centerX = self.contentView.bounds.centerX
        self.emailLabel.width = min(self.emailLabel.width, self.contentView.bounds.width)
        self.emailLabel.top = self.userNameLabel.bottom + Metrics.emailTop
        
    }
}

extension ProfileMenuItemCell {
    class func size(_ width: CGFloat) -> CGSize {
        let height: CGFloat =
            snap(Font.userName.lineHeight)
            + Metrics.emailTop
            + snap(Font.email.lineHeight)
        return .init(width: width, height: height)
    }
}

