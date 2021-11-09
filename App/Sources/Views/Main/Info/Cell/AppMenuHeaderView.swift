//
//  AppMenuHeaderView.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import Foundation
import UIKit

class AppMenuHeaderView: UICollectionReusableView {
    
    private struct Metrics {
        static let margin: CGFloat = 8
    }
    
    private struct Font {
        static let title: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 14)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.title
        label.textColor = ColorName.appMenuHeaderTitle.color
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [self.titleLabel].forEach {
            self.addSubview($0)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metrics.margin)
            $0.centerY.equalToSuperview()
            
        }
        self.backgroundColor = ColorName.appMenuHeaderBG.color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setHeaderTitle(_ title: String) {
        self.titleLabel.text = title
    }
}

extension AppMenuHeaderView {
    class func size(_ width: CGFloat) -> CGSize {
        let top = Metrics.margin
        let bottom = Metrics.margin
        let height: CGFloat =
            top
            + snap(Font.title.lineHeight)
            + bottom
        
        return .init(width: width, height: height)
    }
}
