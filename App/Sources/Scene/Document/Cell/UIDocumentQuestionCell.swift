//
//  AttributeQuestionCell.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit


class UIDocumentQuestionCell: UICollectionViewCell {
    
    private struct Metrics {
        static let margin: CGFloat = 10
    }
    
    private struct Font {
        static let question: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 18)
    }
                                
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.question
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.questionLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(_ question: DocumentAttrQuestion) {
        self.questionLabel.text = question.text
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.questionLabel.sizeToFit()
        let contentViewBounds = self.contentView.bounds
        self.questionLabel.frame = .init(x: contentViewBounds.left, y: contentViewBounds.top, width: contentViewBounds.width, height: contentViewBounds.height)
    }
}

extension UIDocumentQuestionCell {
    
    class func size(_ width: CGFloat, question: DocumentAttrQuestion) -> CGSize {
        let height = snap(question.text.height(thatFitsWidth: width, font: Font.question, maximumNumberOfLines: 0))
        return .init(width: width, height: height)
    }
}

