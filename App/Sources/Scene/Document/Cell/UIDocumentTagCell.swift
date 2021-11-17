//
//  BuildUpTagCell.swift
//  App
//
//  Created by tyler on 2021/11/11.
//

import Foundation
import UIKit
import TagListView

class UIDocumentTagCell: UICollectionViewCell {
    
    private struct Font {
        static let tag: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 14)
    }
    private let tagListView: TagListView = {
        let tagListView = TagListView()
        tagListView.textFont = Font.tag
        tagListView.textColor = .white
        tagListView.tagBackgroundColor = ColorName.primary.color
        tagListView.cornerRadius = 8
        tagListView.paddingX = 5
        tagListView.paddingY = 5
        tagListView.marginX = 5
        tagListView.marginY = 5
        
        return tagListView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.tagListView)
        
        self.tagListView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.tagListView.removeAllTags()
    }
    
    func configCell(tags: [String]) {
        self.tagListView.removeAllTags()
        self.tagListView.addTags(tags)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let contentViewBounds = self.contentView.bounds
        self.tagListView.frame = .init(x: contentViewBounds.left, y: contentViewBounds.top, width: contentViewBounds.width, height: contentViewBounds.height)
    }
}

extension UIDocumentTagCell {
    
    class func size(_ width: CGFloat, tags: [String]) -> CGSize {
        return .init(width: width, height: 80)
    }
}
