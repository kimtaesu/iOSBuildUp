//
//  AppInfoViewController.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import UIKit

class AppMenuViewController: UIViewController {
  
  init(reactor: Reactor) {
    super.init(nibName: nil, bundle: nil)
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

extension AppMenuViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = AppMenuViewReactor
    
    func bind(reactor: Reactor) {
            
    }
}
