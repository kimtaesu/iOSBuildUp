//
//  UISignViewController.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import Foundation
import UIKit

class UISignViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let joinIconView: UIImageView = {
        let image = UIImageView()
        image.image = Asset.joinIcon.image
        return image
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 함께 빌드업!\n해봐요"
        label.numberOfLines = 2
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 모두\n할 수 있습니다."
        label.numberOfLines = 2
        return label
    }()
    
    private let googleSignButton: UIButton = {
        let button = UIButton()
        button.setTitle("구글로 시작하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(Asset.google.image, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    private let appleSignButton: UIButton = {
        let button = UIButton()
        button.setTitle("애플로 시작하기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setImage(Asset.apple.image, for: .normal)
        button.backgroundColor = .black
        return button
    }()
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.googleSignButton.addTarget(self, action: #selector(self.googleTouch), for: .touchUpInside)
        [self.joinIconView, self.titleLabel, self.googleSignButton, self.appleSignButton].forEach {
            self.contentView.addSubview($0)
        }
        
        
        self.scrollView.addSubview(self.contentView)
        self.view.addSubview(self.scrollView)
    }
    
    override func setupConstraints() {
        
        self.scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        self.contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        self.joinIconView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(self.joinIconView.snp.width)
        }
        
        self.titleLabel.snp.makeConstraints {
            $0.top.equalTo(self.joinIconView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        self.googleSignButton.snp.makeConstraints {
            $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self.titleLabel)
        }
        
        self.appleSignButton.snp.makeConstraints {
            $0.top.equalTo(self.googleSignButton.snp.bottom).offset(20)
            $0.leading.trailing.equalTo(self.titleLabel)
            $0.bottom.equalToSuperview()
        }
//        self.subtitleLabel.snp.makeConstraints {
//            $0.top.equalTo(self.titleLabel.snp.bottom).offset(20)
//            $0.leading.trailing.equalTo(self.titleLabel)
//            $0.bottom.equalToSuperview()
//        }
    }
    
    @objc func googleTouch() {
    }
}

import ReactorKit

extension UISignViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UISignViewReactor
    
    func bind(reactor: Reactor) {
        
    }
}

