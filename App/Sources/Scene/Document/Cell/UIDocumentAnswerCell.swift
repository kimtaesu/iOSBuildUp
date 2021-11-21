//
//  CheckAnswerCell.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit
import M13Checkbox

class UIDocumentAnswerCell: UICollectionViewCell {
    
    private struct Metrics {
        static let left: CGFloat = 16
        static let right: CGFloat = left
        static let top: CGFloat = 10
        static let bottom: CGFloat = top
        static let checkBoxLeft: CGFloat = 10
        static let checkBoxSize: CGFloat = 24
    }
    
    private struct Font {
        static let answers: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 18)
    }
    
    public static var borderColor: UIColor?
    
    private let answersLabel: UILabel = {
        let label = UILabel()
        label.font = Font.answers
        label.numberOfLines = 2
        return label
    }()
    
    private let checkBox: M13Checkbox = {
        let checkBox = M13Checkbox()
        checkBox.isUserInteractionEnabled = false
        checkBox.markType = .checkmark
        checkBox.stateChangeAnimation = .fill
        checkBox.checkmarkLineWidth = 1.5
        return checkBox
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 2
        self.checkBox.secondaryTintColor = Self.borderColor
        self.layer.borderColor = Self.borderColor?.cgColor
        [self.answersLabel, self.checkBox].forEach {
            self.contentView.addSubview($0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.checkBox.checkState = .unchecked
        self.disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.layer.cornerRadius = floor(self.height / 4)
        
        self.checkBox.sizeToFit()
        self.checkBox.size = .init(width: Metrics.checkBoxSize, height: Metrics.checkBoxSize)
        self.checkBox.right = self.bounds.right - Metrics.right
        self.checkBox.centerY = self.bounds.centerY
        
        self.answersLabel.sizeToFit()
        self.answersLabel.left = self.bounds.left + Metrics.left
        self.answersLabel.top = self.bounds.top
        self.answersLabel.width = self.checkBox.left - Metrics.checkBoxLeft - self.answersLabel.left
        self.answersLabel.height = self.bounds.height
    }
}

import RxGesture
import ReactorKit

extension UIDocumentAnswerCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIDocumentAnswerCellReactor
    
    func bind(reactor: Reactor) {
        
        self.rx.tapGestureEnded()
            .subscribe(onNext: { _ in
                CheckChoice.event.onNext(.setChecked(docId: reactor.currentState.docId, reactor.currentState.choice))
                // TODO: haptic feedback
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isChecked }
            .distinctUntilChanged()
            .bind(to: self.checkBox.rx.isChecked(animation: false))
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.answers }
            .distinctUntilChanged()
            .bind(to: self.answersLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}

extension UIDocumentAnswerCell {
    class func size(_ width: CGFloat, _ reactor: UIDocumentAnswerCellReactor) -> CGSize {
        let left = Metrics.left
        let right = Metrics.right
        let top = Metrics.top
        let bottom = Metrics.bottom
        
        let fitsWidth = width - (Metrics.checkBoxSize + Metrics.checkBoxLeft + left + right)
        let answersHeight = snap(reactor.currentState.answers.height(thatFitsWidth: fitsWidth, font: Font.answers, maximumNumberOfLines: 2))

        let height = top
        + max(Metrics.checkBoxSize, answersHeight)
        + bottom
        
        return .init(width: width, height: height)
    }
}
