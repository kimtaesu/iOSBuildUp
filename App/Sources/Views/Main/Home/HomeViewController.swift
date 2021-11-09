//
//  HomeViewController.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import UIKit

class HomeViewController: BaseViewController {
    init(reactor: Reactor) {
        super.init()
        self.reactor = reactor
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

import ReactorKit

extension HomeViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = HomeViewReactor
  
    func bind(reactor: Reactor) {
    
    }
}
