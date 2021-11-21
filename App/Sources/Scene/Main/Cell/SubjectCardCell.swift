//
//  MainCardCell.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import Foundation
import UIKit

class SubjectCardCell: UICollectionViewCell {
    
    private struct Metrics {
        static let subjectLeft: CGFloat = 24
        static let padding: CGFloat = 16
        static let countTop: CGFloat = 6
        
        static let cellHeight: CGFloat = 120
        static let iconPadding: CGFloat = 10
        static let iconSize: CGFloat = cellHeight - (iconPadding * 2)
        
    }
    
    private struct Font {
        static let count: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 14)
        static let subject: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 20)
    }
    
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: []) {
                if self.isHighlighted {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                } else {
                    self.transform = .identity
                }
            }
        }
    }
    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let subjectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.subject
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = Font.count
        label.textColor = .white.withAlphaComponent(0.6)
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        return view
    }()
    
    private var gradientLayer: CAGradientLayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.dividerView)
        self.contentView.addSubview(self.subjectLabel)
        self.contentView.addSubview(self.countLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.dividerView.left = self.bounds.left + Metrics.padding
        self.dividerView.width = 3
        self.dividerView.top  = self.bounds.top + Metrics.subjectLeft
        self.dividerView.height = Font.subject.lineHeight
        
        self.subjectLabel.sizeToFit()
        self.subjectLabel.left = self.dividerView.right + Metrics.padding
        self.subjectLabel.top = self.dividerView.top
        
        self.countLabel.sizeToFit()
        self.countLabel.left = self.subjectLabel.left
        self.countLabel.top = self.subjectLabel.bottom + Metrics.countTop
        
        let iconSize: CGSize = .init(width: Metrics.iconSize, height: Metrics.iconSize)
        self.thumbnailImageView.sizeToFit()
        self.thumbnailImageView.size = iconSize
        self.thumbnailImageView.right = self.bounds.right - Metrics.iconPadding
        self.thumbnailImageView.top = self.bounds.top + Metrics.iconPadding
    }
    
    private func setGradientLayer(color: UIColor) {
        self.gradientLayer?.removeFromSuperlayer()
        self.gradientLayer = nil
        if self.gradientLayer == nil {
            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.4).cgColor]
            gradientLayer.frame = self.bounds
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            gradientLayer.masksToBounds = false
            gradientLayer.cornerRadius = round(self.height / 5)
            gradientLayer.shadowOffset = .init(width: 0, height: 1.5)
            gradientLayer.shadowColor = color.cgColor
            gradientLayer.shadowOpacity = 0.4
            gradientLayer.shadowRadius = 10
            self.layer.insertSublayer(gradientLayer, at: 0)
            self.gradientLayer = gradientLayer
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.countLabel.text = ""
        self.disposeBag = DisposeBag()
        self.thumbnailImageView.kf.cancelDownloadTask()
    }
}

import RxGesture
import ReactorKit

extension SubjectCardCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = SubjectCardCellReactor
    
    func bind(reactor: Reactor) {
        Observable.just(true)
            .map { _ in Reactor.Action.listenDocument }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.item }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.configCell(item)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.answerText }
            .filterNil()
            .distinctUntilChanged()
            .do(afterNext: { [weak self] _ in
                self?.countLabel.sizeToFit()
            })
            .bind(to: self.countLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    private func configCell(_ item: DocumentSubject) {
        self.subjectLabel.text = item.title
        self.setGradientLayer(color: UIColor(hex: item.color))
        self.thumbnailImageView.alpha = 0.6
        self.thumbnailImageView.kf.setImage(with: URL(string: item.thumbnail ?? ""), options: [.transition(.fade(1))])
    }
}

extension SubjectCardCell {
    class func size(_ width: CGFloat, _ reactor: SubjectCardCellReactor) -> CGSize {
        return .init(width: width, height: Metrics.cellHeight)
    }
}
