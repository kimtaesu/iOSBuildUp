//
//  ViewController.swift
//  iOSBuildUp
//
//  Created by tyler on 2021/11/07.
//

import UIKit
import XCoordinator

// https://icons8.com/icons/set/tetris
class SplashViewController: UIViewController {
  
    private let router: StrongRouter<AppRoute>

    init(router: StrongRouter<AppRoute>) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
      super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() +  0.3) {
            self.router.trigger(.home)
        }
    }
}
