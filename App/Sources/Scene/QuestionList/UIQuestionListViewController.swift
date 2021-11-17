//
//  DocListViewController.swift
//  App
//
//  Created by tyler on 2021/11/15.
//

import Foundation
import UIKit
import ReusableKit
import RxDataSources
import FirebaseFirestore
import BetterSegmentedControl

class UIQuestionListViewController: BaseViewController {
    
    private struct Reusable {
        static let listItem = ReusableCell<QuestionListItemCell>()
    }
    
    private struct Metrics {
        static let margin: CGFloat = 16
        static let segmentHeight: CGFloat = 40
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<QuestionListSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .listItem(let reactor):
            let cell = collectionView.dequeue(Reusable.listItem, for: indexPath)
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
        collectionView.register(Reusable.listItem)
        return collectionView
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
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
     }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func setupNavigationBarItems() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: self.backImage, style: .plain, target: self, action: #selector(self.back))
    }
    
    
    @objc func back() {
        self.dismiss(animated: true) {
            
        }
    }
}


extension UIQuestionListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        
        switch self.dataSource[indexPath] {
        case .listItem(let reactor):
            return Reusable.listItem.class.size(sectionWidth, reactor: reactor)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .list:
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.dataSource[section] {
        case .list:
            return .init(top: Metrics.margin, left: Metrics.margin, bottom: Metrics.margin, right: Metrics.margin)
        }
    }
}

import ReactorKit

extension UIQuestionListViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIQuestionListViewReactor
    
    func bind(reactor: Reactor) {
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.listenQuestions }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)

        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

