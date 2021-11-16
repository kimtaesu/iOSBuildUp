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
        static let titleLeft: CGFloat = 16
        static let left: CGFloat = 16
        static let right: CGFloat = 16
        static let bottom: CGFloat = 16
        static let thumbSize: CGFloat = 80
    }
    private struct Font {
        static let count: UIFont = FontFamily.NotoSansCJKKR.regular.font(size: 14)
        static let title: UIFont = FontFamily.NotoSansCJKKR.medium.font(size: 20)
    }
    
    private let thumbnailImageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.title
        return label
    }()
    
    private let buildUpCountLabel: UILabel = {
        let label = UILabel()
        label.font = Font.count
        label.textColor = .white
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.contentView.backgroundColor = ColorName.cardBg.color
        
        self.thumbnailImageView.layer.cornerRadius = Metrics.thumbSize / 2
        self.thumbnailImageView.layer.masksToBounds = true

        [self.thumbnailImageView, self.titleLabel, self.buildUpCountLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        self.thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(Metrics.left)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metrics.thumbSize)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.leading.equalTo(self.thumbnailImageView.snp.trailing).offset(Metrics.titleLeft)
            $0.trailing.equalToSuperview().inset(Metrics.right)
            $0.top.equalTo(self.thumbnailImageView)
        }
        
        self.buildUpCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(self.titleLabel)
            $0.bottom.equalToSuperview().inset(Metrics.bottom)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            .map { _ in Reactor.Action.getCompletedCount }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.item }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                self.configCell(item)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.buildUpCount }
            .distinctUntilChanged()
            .bind(to: self.buildUpCountLabel.rx.text)
            .disposed(by: self.disposeBag)
    }
    
    private func configCell(_ item: BuildUpSubject) {
        self.titleLabel.text = item.title
        self.thumbnailImageView.kf.indicatorType = .activity
        self.thumbnailImageView.kf.setImage(with: URL(string: item.thumbnail ?? ""))
    }
}

extension SubjectCardCell {
    class func size(_ width: CGFloat, _ reactor: SubjectCardCellReactor) -> CGSize {
        return .init(width: width, height: 100)
    }
}
