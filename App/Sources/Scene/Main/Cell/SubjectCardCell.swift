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
        static let padding: CGFloat = 24
    }
    
    private struct Font {
        static let count: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 14)
        static let subject: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 20)
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
//
//        self.thumbnailImageView.layer.cornerRadius = Metrics.thumbSize / 2
//        self.thumbnailImageView.layer.masksToBounds = true
//
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.dividerView)
        self.contentView.addSubview(self.subjectLabel)
        self.contentView.addSubview(self.countLabel)
//
//        self.thumbnailImageView.snp.makeConstraints {
//            $0.leading.equalToSuperview().inset(Metrics.left)
//            $0.centerY.equalToSuperview()
//            $0.size.equalTo(Metrics.thumbSize)
//        }
//
//        self.titleLabel.snp.makeConstraints {
//            $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Metrics.titleLeft)
//            $0.trailing.equalToSuperview().inset(Metrics.right)
//            $0.top.equalTo(self.thumbnailImageView)
//        }
//
//        self.buildUpCountLabel.snp.makeConstraints {
//            $0.trailing.equalTo(self.titleLabel)
//            $0.bottom.equalToSuperview().inset(Metrics.bottom)
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.masksToBounds = false
        self.dividerView.left = self.bounds.left + 16
        self.dividerView.width = 3
        self.dividerView.top  = self.bounds.top + 24
        self.dividerView.height = Font.subject.lineHeight
        
        self.subjectLabel.sizeToFit()
        self.subjectLabel.left = self.dividerView.right + 16
        self.subjectLabel.top = self.dividerView.top
        
        
        self.countLabel.sizeToFit()
        self.countLabel.left = self.subjectLabel.left
        self.countLabel.top = self.subjectLabel.bottom + 6
        
        let iconSize: CGSize = .init(width: self.height, height: self.height)
        self.thumbnailImageView.sizeToFit()
        self.thumbnailImageView.size = iconSize
        self.thumbnailImageView.right = self.bounds.right  - 16
        self.thumbnailImageView.top = self.bounds.top
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
            gradientLayer.cornerRadius = snap(self.height / 5)
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
    }
    
    private func configCell(_ item: DocumentSubject) {
        self.subjectLabel.text = item.title
        self.setGradientLayer(color: UIColor(hex: item.color))
        self.thumbnailImageView.alpha = 0.6
        self.thumbnailImageView.kf.setImage(with: URL(string: item.thumbnail ?? ""))
        self.countLabel.text = "3문제 남았어요."
    }
}

extension SubjectCardCell {
    class func size(_ width: CGFloat, _ reactor: SubjectCardCellReactor) -> CGSize {
        return .init(width: width, height: 120)
    }
}
