//
//  CheckAnswerCell.swift
//  App
//
//  Created by tyler on 2021/11/10.
//

import UIKit
import SimpleCheckbox

class CheckChoiceCell: UICollectionViewCell {
    
    private struct Metrics {
        static let left: CGFloat = 16
        static let right: CGFloat = left
        static let top: CGFloat = 10
        static let bottom: CGFloat = top
        static let checkBoxLeft: CGFloat = 10
        static let checkBoxSize: CGFloat = 20
    }
    
    private struct Font {
        static let answers: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 16)
    }
    
    private let answersLabel: UILabel = {
        let label = UILabel()
        label.font = Font.answers
        label.numberOfLines = 2
        return label
    }()
    
    private let circleBox: Checkbox = {
        let circleBox = Checkbox()
        circleBox.borderStyle = .circle
        circleBox.checkmarkStyle = .circle
        circleBox.borderLineWidth = 1
        circleBox.uncheckedBorderColor = .lightGray
        circleBox.checkedBorderColor = ColorName.accent.color
        circleBox.checkmarkColor = ColorName.accent.color
        circleBox.checkmarkSize = 0.6
        return circleBox
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 1
        self.layer.borderColor = ColorName.primary.color.cgColor
        [self.answersLabel, self.circleBox].forEach {
            self.contentView.addSubview($0)
        }
        
        self.answersLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Metrics.left)
            $0.centerY.equalToSuperview()
        }
        
        self.circleBox.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Metrics.right)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metrics.checkBoxSize)
            $0.leading.equalTo(self.answersLabel.snp.trailing).offset(Metrics.checkBoxLeft)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = floor(self.height / 4)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        
        if hitView == self.contentView {
            return self.circleBox
        }
        return hitView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}


import ReactorKit

extension CheckChoiceCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = CheckChoiceCellReactor
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.answers }
            .distinctUntilChanged()
            .bind(to: self.answersLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
}

extension CheckChoiceCell {
    class func size(_ width: CGFloat, _ reactor: CheckChoiceCellReactor) -> CGSize {
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

