//
//  BaseViewController.swift
//  App
//
//  Created by tyler on 2021/11/09.
//

import UIKit

import RxSwift

class BaseViewController: UIViewController {

    var centerTitle: String? {
        didSet {
            guard let centerTitle = centerTitle, centerTitle.isNotEmpty else { return }
            self.centerTitleLabel.text = centerTitle
            self.centerTitleLabel.sizeToFit()
            
            if self.centerTitleLabel.superview == nil {
                self.navigationItem.titleView = self.centerTitleLabel
            }
        }
    }
    
    private let centerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = FontFamily.NotoSansCJKKR.medium.font(size: 18)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    open var backImageSize: CGSize {
        return .init(width: 30, height: 30)
    }
    
    open var backImage: UIImage? {
        if self.presentingViewController != nil { // presented
            return Asset.close.image.resizeImage(size: self.backImageSize).withRenderingMode(.alwaysOriginal)
        }
        
        return Asset.arrowBack.image.resizeImage(size: self.backImageSize).withRenderingMode(.alwaysOriginal)
    }

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
