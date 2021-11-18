//
//  BuildUpDocumentCell.swift
//  App
//
//  Created by tyler on 2021/11/17.
//

import Foundation
import UIKit
import ReusableKit
import RxDataSources

class UIDocumentCell: UICollectionViewCell {
    
    private struct Reusable {
        static let question = ReusableCell<UIDocumentQuestionCell>()
        static let checkChioce = ReusableCell<UIDocumentAnswerCell>()
        static let tag = ReusableCell<UIDocumentTagCell>()
    }
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = .zero
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.question)
        collectionView.register(Reusable.checkChioce)
        collectionView.register(Reusable.tag)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        return collectionView
    }()
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<DocumentSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .question(let q):
            let cell = collectionView.dequeue(Reusable.question, for: indexPath)
            cell.configCell(q)
            return cell
        case .checkChioce(let reactor):
            let cell = collectionView.dequeue(Reusable.checkChioce, for: indexPath)
            cell.reactor = reactor
            return cell
        case .tags(let tags):
            let cell = collectionView.dequeue(Reusable.tag, for: indexPath)
            cell.configCell(tags: tags)
            return cell
        }
    })
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.contentView.frame
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}

extension UIDocumentCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        
        switch self.dataSource[indexPath] {
        case .question(let q):
            return Reusable.question.class.size(sectionWidth, question: q)
        case .checkChioce(let reactor):
            return Reusable.checkChioce.class.size(sectionWidth, reactor)
        case .tags(let tags):
            return Reusable.tag.class.size(sectionWidth, tags: tags)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch self.dataSource[section] {
        case .answers:
            return 8
        case .questions, .tag:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var inset: UIEdgeInsets = .zero
        inset.left = 16
        inset.right = 16
        inset.top = 8
        inset.bottom = 8
        
        switch self.dataSource[section] {
        case .questions:
            return inset
        case .tag:
            return inset
        case .answers:
            return inset
        }
    }
}

import ReactorKit

extension UIDocumentCell: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIDocumentCellReactor
    
    func bind(reactor: Reactor) {
        Observable.just(true)
            .map { _ in Reactor.Action.listen }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
}

