//
//  UICorrectAnimationView.swift
//  App
//
//  Created by tyler on 2021/11/19.
//

import Foundation
import Lottie
import UIKit

enum AnswerAnimationType {
    
    init(isCorrect: Bool) {
        if isCorrect {
            self = .correct
        } else {
            self = .wrong
        }
    }
    
    case correct
    case wrong
        
    var animation: Animation? {
        switch self {
        case .correct:
            return Animation.named("document-correct")
        case .wrong:
            return Animation.named("document-wrong")
        }
    }
    
    var title: String {
        switch self {
        case .correct:
            return "정답"
        case .wrong:
            return "오답"
        }
    }
    
    var phrase: String {
        switch self {
        case .correct:
            return "입니다."
        case .wrong:
            return "입니다."
        }
    }
    
    var color: UIColor {
        switch self {
        case .correct:
            return ColorName.correct.color
        case .wrong:
            return ColorName.wrong.color
        }
    }
}

class UIAnswerAnimationView: UIView {
    
    private struct Metrics {
        static let padding: CGFloat = 12
        static let animtionWidth: CGFloat = 80
    }
    
    private struct Font {
        static let answer: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 24)
        static let phrase: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 16)
    }
    
    private let animationView = AnimationView()
    
    private let answerLabel: UILabel = {
        let label = UILabel()
        label.font = Font.answer
        label.textColor = .white
        return label
    }()
    
    init(type: AnswerAnimationType) {
        super.init(frame: .zero)
        self.addSubview(self.animationView)
        self.addSubview(self.answerLabel)
        self.setAnimationType(type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 5
        self.layer.masksToBounds = true
        
        self.animationView.top = self.bounds.top + Metrics.padding
        self.animationView.width = Metrics.animtionWidth
        self.animationView.height = Metrics.animtionWidth
        self.animationView.centerX = self.bounds.centerX
        
        self.answerLabel.sizeToFit()
        self.answerLabel.top = self.animationView.bottom
        self.answerLabel.centerX = self.bounds.centerX
    }
    
    private func setAnimationType(_ type: AnswerAnimationType) {
        
        self.animationView.animation = type.animation
        
        let attributedText = NSMutableAttributedString(
            attributedString: NSAttributedString(string: type.title, attributes: [.font: Font.answer]))
        attributedText.append(NSAttributedString(string: type.phrase, attributes: [.font: Font.phrase]))
        
        self.backgroundColor = type.color
        self.answerLabel.attributedText = attributedText
    }
    
    private func startAnimation() {
        self.animationView.play(
            fromProgress: 0,
            toProgress: 1,
            loopMode: LottieLoopMode.playOnce,
            completion: { [weak self] finished in
                self?.hide()
        })
        
    }
    
    func hide() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    func show(superView: UIView) {
        self.alpha = 0
        superView.addSubview(self)
        self.size = self.intrinsicContentSize
        self.center = superView.center
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.alpha = 1
        } completion: { _ in
            self.startAnimation()
        }

    }
    
    override var intrinsicContentSize: CGSize {
        let height = Metrics.padding
        + Metrics.animtionWidth
        + snap(Font.answer.lineHeight)
        + Metrics.padding
        
        return .init(width: height, height: height)
    }
}
