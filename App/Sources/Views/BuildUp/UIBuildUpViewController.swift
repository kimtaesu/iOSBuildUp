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
import ReusableKit
import RxDataSources

class UIBuildUpViewController: BaseViewController {
    
    private struct Reusable {
        static let question = ReusableCell<AttributeQuestionCell>()
        static let checkChioce = ReusableCell<CheckChoiceCell>()
    }

    private struct Metrics {
        static let buttonHeight: CGFloat = 44
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<BuildUpSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .question(let q):
            let cell = collectionView.dequeue(Reusable.question, for: indexPath)
            cell.configCell(q)
            return cell
        case .checkChioce(let reactor):
            let cell = collectionView.dequeue(Reusable.checkChioce, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    })
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.checkChioce)
        collectionView.register(Reusable.question)
        return collectionView
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 16)
        button.setBackgroundColor(ColorName.primary.color, for: .normal)
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
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.nextButton)
    }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Metrics.buttonHeight)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}


extension UIBuildUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        let sectionHeight = collectionView.sectionHeight(at: indexPath.section)
        
        switch self.dataSource[indexPath] {
        case .question(let q):
            return Reusable.question.class.size(sectionWidth, sectionHeight, question: q)
        case .checkChioce(let reactor):
            return Reusable.checkChioce.class.size(sectionWidth, reactor)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .answers:
            return 8
        case .questions:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var inset: UIEdgeInsets = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        switch self.dataSource[section] {
        case .questions:
            return inset
        case .answers:
            return inset
        }
        
    }
}

import ReactorKit

extension UIBuildUpViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIBuildUpViewReactor
    
    func bind(reactor: Reactor) {
        
        self.rx.viewDidLoad
            .map { Reactor.Action.nextQuestion }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

