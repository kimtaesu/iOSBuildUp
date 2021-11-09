//
//  UISolvingViewController.swift
//  App
//
//  Created by tyler on 2021/11/08.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class UIBuildUpViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.label)
        
        let db = Firestore.firestore()
        let document = db.collection("users").document()
        document.getDocument { snapshot, error in
            if let error = error {
            } else {
            }
        }
        self.label.text = "문제풀기 화면입니다."
        self.label.frame = .init(x: 100, y: 100, width: 100, height: 100)
    }
    
}

import ReactorKit

extension UIBuildUpViewController: ReactorKit.View {
    typealias Reactor = UIBuildUpViewReactor
    
    func bind(reactor: Reactor) {
        
    }
}

