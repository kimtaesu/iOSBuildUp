//
//  MainViewContoller.swift
//  App
//
//  Created by tyler on 2021/11/13.
//

import Foundation
import UIKit
import ReusableKit
import RxDataSources
import FirebaseFirestore

class MainViewContoller: BaseViewController {
    
    private struct Reusable {
        static let card = ReusableCell<MainCardCell>()
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<MainViewSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .card(let reactor):
            let cell = collectionView.dequeue(Reusable.card, for: indexPath)
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
        collectionView.register(Reusable.card)
        return collectionView
    }()
 
    private let buildUpViewScreen: (MainCardModel) -> UIBuildUpViewController
    init(
        reactor: Reactor,
        buildUpViewScreen: @escaping (MainCardModel) -> UIBuildUpViewController
    ) {
        defer { self.reactor = reactor }
        self.buildUpViewScreen = buildUpViewScreen
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.collectionView)
    }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension MainViewContoller: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case .card(let reactor):
            return Reusable.card.class.size(sectionWidth, reactor)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.dataSource[section] {
        case .cards:
            return .init(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

import ReactorKit

extension MainViewContoller: ReactorKit.View, HasDisposeBag {
    typealias Reactor = MainViewReactor
    
    func bind(reactor: Reactor) {
        
        self.collectionView.rx.itemSelected
            .map { indexPath in self.dataSource[indexPath] }
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case .card(let reactor):
                    let buildUpViewController = self.buildUpViewScreen(reactor.currentState.item)
                    self.navigationController?.pushViewController(buildUpViewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
    }
}

