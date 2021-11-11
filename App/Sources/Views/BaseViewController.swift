//
//  BaseViewController.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {

    // MARK: Properties
    lazy private(set) var className: String = {
        return type(of: self).description().components(separatedBy: ".").last ?? ""
    }()

    // MARK: Initializing
    init() {
      super.init(nibName: nil, bundle: nil)
    }

    required convenience init?(coder aDecoder: NSCoder) {
      self.init()
    }

    deinit {
        logger.debug("DEINIT: \(self.className)")
    }


    // MARK: View Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarItems()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

  // MARK: Layout Constraints
        private(set) var didSetupConstraints = false

    override func viewDidLoad() {
        self.view.setNeedsUpdateConstraints()
    }

    override func updateViewConstraints() {
        if !self.didSetupConstraints {
            self.setupConstraints()
            self.didSetupConstraints = true
        }
        super.updateViewConstraints()
    }

    func setupConstraints() {
      // Override point
    }
    
    func setupNavigationBarItems() {
      // Override point
    }
}
