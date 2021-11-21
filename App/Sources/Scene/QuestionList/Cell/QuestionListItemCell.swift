//
//  QuestionListItemCell.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation
import UIKit
import TagListView
import M13Checkbox

enum AnswerType {
    case correct
    case wrong
    case notYet
    
    var icon: UIImage {
        switch self {
        case .correct:
            return Asset.correct.image
        case .wrong:
            return Asset.incorrect.image
        case .notYet:
            return Asset.answerNotYet.image
        }
    }
    
    var color: UIColor {
        switch self {
        case .correct:
            return ColorName.answerCorrect.color
        case .wrong:
            return ColorName.answerWrong.color
        case .notYet:
            return ColorName.answerNotYet.color
        }
    }
    
    var title: String {
        switch self {
        case .correct:
            return "정답"
        case .wrong:
            return "오답"
        case .notYet:
            return "문제풀기"
        }
    }
}

class QuestionListItemCell: UICollectionViewCell {
    
    private struct Metrics {
        static let answerIconSize: CGFloat = 40
        static let answerPadding: CGFloat = 32
        static let cellMinHeight: CGFloat = 80
        static let cellMaxHeight: CGFloat = 160
        static let padding: CGFloat = 10
    }
    
    private struct Font {
        static let question: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 16)
    }
    private let tagListView: TagListView = {
        let tagListView = TagListView()
        return tagListView
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = Font.question
        return label
    }()
    
    
    private var answerType: AnswerType = .notYet {
        didSet {
            switch self.answerType {
            case .correct:
                self.answerImageView.image = Asset.correct.image.withRenderingMode(.alwaysTemplate)
                self.answerImageView.tintColor = ColorName.
            case .wrong:
                break
            case .notYet:
                break
            }
    }
    
    private let questionView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let answerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let answerImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let submitDateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        [self.tagListView, self.questionLabel].forEach {
            self.questionView.addSubview($0)
        }
        [self.answerImageView].forEach {
            self.answerView.addSubview($0)
        }
        
        [self.questionView, self.answerView].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // MARK: Answer Views
        self.answerView.right = self.bounds.right
        self.answerView.width = Metrics.answerIconSize + Metrics.answerPadding
        self.answerView.height = self.bounds.height
        
        self.answerImageView.size = .init(width: Metrics.answerIconSize, height: Metrics.answerIconSize)
        self.answerImageView.centerX = self.answerView.centerX
        self.answerImageView.centerY = self.answerView.centerY
        
        // MARK: Question Views
//
//        self.questionView.left = self.bounds.left
//        self.questionView.top = self.bounds.top
//
//
//        let tagHeight = TagListView.height(maxLine: 1)
//        self.tagListView.left = self.bounds.left
//        self.tagListView.top = self.bounds.top
//
//        self.tagListView.width = self.bounds.width - self.tagListView.left
//        self.tagListView.height = tagHeight
//        self.tagListView.layer.masksToBounds = true
//
//        self.questionLabel.sizeToFit()
//        self.questionLabel.top = self.tagListView.bottom
//        self.questionLabel.left = self.tagListView.left
//
//        let textWidth = self.bounds.width - self.questionLabel.left
//        let textViewHeight = self.bounds.height - tagHeight
//        self.questionLabel.width = textWidth
//        let textHeight = self.questionLabel.text?.height(thatFitsWidth: textWidth, font: Font.question, maximumNumberOfLines: 0) ?? textViewHeight
//        self.questionLabel.height = min(textViewHeight, textHeight)
        
//        self.answerView.top = self.bounds.top
//        self.answerView.left = self.bounds.left
//        self.answerView.size = .init(width: Metrics.answerIconSize, height: self.bounds.height)
        
    }
}

import ReactorKit

extension QuestionListItemCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = QuestionListItemCellReactor
    
    func bind(reactor: Reactor) {
        
        
        reactor.state
            .map { $0.doc.answer }
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] answer in
                guard let self = self else { return }
                if answer.isCorrect {
                    self.answerImageView.image = Asset.correct.image.withRenderingMode(.alwaysTemplate)
                    self.answerImageView.tintColor = ColorName.correct.color
                } else {
                    self.answerImageView.image = Asset.incorrect.image.withRenderingMode(.alwaysTemplate)
                    self.answerImageView.tintColor = ColorName.wrong.color
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.doc }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] doc in
                guard let self = self else { return }
                self.configCell(doc)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configCell(_ data: QuestionJoinAnswer) {
        self.tagListView.removeAllTags()
        self.tagListView.addTags(data.question.tags)
        self.questionLabel.text = data.question.question.text + data.question.question.text
    }
}

extension QuestionListItemCell {
    class func size(_ width: CGFloat, reactor: Reactor) -> CGSize {
        let tagHeight = TagListView.height(maxLine: 1)
        let questionText = reactor.currentState.doc.question.question.text
        
        
        let answerWidth = Metrics.answerIconSize + Metrics.answerRight
        let textHeight = questionText.height(thatFitsWidth: width - answerWidth, font: Font.question, maximumNumberOfLines: 5)
        return .init(width: width, height: 80)
    }
}
