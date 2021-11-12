//
//  AttributeQuestionCell.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit


class BuildUpQuestionCell: UICollectionViewCell {
    
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
        
        [self.questionLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        self.questionLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(_ question: AttributeQuestion) {
        self.questionLabel.text = question.question
    }
}

extension BuildUpQuestionCell {
    class func size(_ width: CGFloat, _ viewHeight: CGFloat, question: AttributeQuestion) -> CGSize {
        let height = snap(question.question.height(thatFitsWidth: width, font: Font.question, maximumNumberOfLines: 0))
        return .init(width: width, height: height)
    }
}

