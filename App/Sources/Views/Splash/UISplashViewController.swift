//
//  ViewController.swift
//  iOSBuildUp
//
//  Created by tyler on 2021/11/07.
//

import UIKit
import XCoordinator

// https://icons8.com/icons/set/tetris
class UISplashViewController: BaseViewController {
  
    private let onNext: () -> Void
    
    init(reactor: Reactor, onNext: @escaping () -> Void) {
        defer { self.reactor = reactor }
        self.onNext = onNext
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
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
        
        reactor.state.map { $0.user }
            .distinctUntilChanged()
            .debug("getUsers")
            .filterNil()
            .take(1)
            .subscribe(onNext: { [weak self] user in
                self?.onNext()
            })
            .disposed(by: self.disposeBag)
    }
}
