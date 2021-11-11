//
//  ViewController.swift
//  iOSBuildUp
//
//  Created by tyler on 2021/11/07.
//

import UIKit
import XCoordinator

// https://icons8.com/icons/set/tetris
class UISplashViewController: UIViewController {
    
    private let launchImageView: UIImageView = {
        let image = UIImageView()
        image.image = Asset.launchTetris.image
        return image
    }()
    
    private let onNext: () -> Void
    init(
        reactor: Reactor,
        onNext: @escaping () -> Void
    ) {
        defer { self.reactor = reactor }
        self.onNext = onNext
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.launchImageView)
        
        self.launchImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(120)
            $0.height.equalTo(self.launchImageView.snp.width)
        }
    }
}

import ReactorKit

extension UISplashViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UISplashViewReactor
  
    func bind(reactor: Reactor) {
        self.rx.viewDidLoad
            .map { Reactor.Action.getUser }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.isNextScreen }
            .distinctUntilChanged()
            .filter { $0 }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                self?.onNext()
            })
            .disposed(by: self.disposeBag)
    }
}
