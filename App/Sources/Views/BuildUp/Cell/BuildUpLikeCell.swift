//
//  DocumentLikeCell.swift
//  App
//
//  Created by tyler on 2021/11/12.
//

import Foundation
import UIKit

class BuildUpLikeCell: UICollectionViewCell {
    
    private struct Metrics {
        static let top: CGFloat = 6
        static let bottom: CGFloat = top
        static let iconSize: CGFloat = 36
    }
    
    private let thumbUpButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.thumbUp.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = ColorName.primary.color
        button.titleLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 14)
        button.setTitleColor(ColorName.primary.color, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.imageEdgeInsets = .zero
        return button
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.starBorder.image.withRenderingMode(.alwaysTemplate), for: .normal)
        button.setImage(Asset.star.image.withRenderingMode(.alwaysTemplate), for: .selected)
        button.tintColor = ColorName.primary.color
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        [self.likeButton, self.thumbUpButton].forEach {
            self.contentView.addSubview($0)
        }
        
        self.thumbUpButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metrics.iconSize)
        }
        
        self.likeButton.snp.makeConstraints {
            $0.leading.equalTo(self.thumbUpButton.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Metrics.iconSize)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}

import ReactorKit

extension BuildUpLikeCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = BuildUpLikeCellReactor
    
    func bind(reactor: Reactor) {
        
        reactor.state.map { $0.thumbUpCnt }
            .distinctUntilChanged()
            .bind(to: self.thumbUpButton.rx.title())
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isLike }
            .distinctUntilChanged()
            .map { isLike in
                if isLike {
                    return Asset.star.image
                } else {
                    return Asset.starBorder.image
                }
            }
            .bind(to: self.likeButton.rx.image())
            .disposed(by: self.disposeBag)
        
    }
}

extension BuildUpLikeCell {
    class func size(_ width: CGFloat) -> CGSize {
        let height: CGFloat = Metrics.top
        + Metrics.iconSize
        + Metrics.bottom
        return .init(width: width, height: height)
    }
}
