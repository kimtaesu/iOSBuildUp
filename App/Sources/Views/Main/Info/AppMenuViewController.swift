//
//  AppInfoViewController.swift
//  App
//
//  Created by tyler on 2021/11/07.
//

import Foundation
import UIKit
import RxDataSources
import ReusableKit

class AppMenuViewController: BaseViewController {

    private struct Reusable {
        static let actionMenu = ReusableCell<ActionMenuItemCell>()
        static let profile = ReusableCell<ProfileMenuItemCell>()
        static let menuItem = ReusableCell<AppMenuItemCell>()
        static let menuHeader = ReusableView<AppMenuHeaderView>()
    }

    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<AppMenuSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .profile:
            let cell = collectionView.dequeue(Reusable.profile, for: indexPath)
            cell.configCell(.init(userName: "김태수", email: "kimtaesoo188@gmail.com"))
            return cell
        case .version:
            let cell = collectionView.dequeue(Reusable.menuItem, for: indexPath)
            cell.configCell(.init(iconName: Asset.github.name, title: "버전"))
            return cell
        case .github:
            let cell = collectionView.dequeue(Reusable.menuItem, for: indexPath)
            cell.configCell(.init(iconName: Asset.github.name, title: "Github"))
            return cell
        case .review:
            let cell = collectionView.dequeue(Reusable.actionMenu, for: indexPath)
            cell.configCell(.init(isAccent: false, title: "리뷰쓰기"))
            return cell
        case .contact:
            let cell = collectionView.dequeue(Reusable.actionMenu, for: indexPath)
            cell.configCell(.init(isAccent: false, title: "문의하기"))
            return cell
        case .logout:
            let cell = collectionView.dequeue(Reusable.actionMenu, for: indexPath)
            cell.configCell(.init(isAccent: true, title: "로그아웃"))
            return cell
        }
    }, configureSupplementaryView: { ds, cv, kind, ip in
        switch kind {
        case SupplementaryViewKind.header.rawValue:
            switch ds[ip.section] {
            case let .sectionHeader(header, _):
                let cell = cv.dequeue(Reusable.menuHeader, kind: kind, for: ip)
                cell.setHeaderTitle(header)
                return cell
            default: break
            }
        default: break
        }
        return UICollectionReusableView()
    })
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.actionMenu)
        collectionView.register(Reusable.profile)
        collectionView.register(Reusable.menuItem)
        collectionView.register(Reusable.menuHeader, kind: .header)
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
        [self.collectionView].forEach {
            self.view.addSubview($0)
        }
    }
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension AppMenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: section)
        switch self.dataSource[section] {
        case .sectionHeader:
            return Reusable.menuHeader.class.size(sectionWidth)
        default: return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        switch self.dataSource[indexPath] {
        case .profile:
            return Reusable.profile.class.size(sectionWidth)
        case .version:
            return Reusable.menuItem.class.size(sectionWidth)
        case .github:
            return Reusable.menuItem.class.size(sectionWidth)
        case .review:
            return Reusable.actionMenu.class.size(sectionWidth)
        case .contact:
            return Reusable.actionMenu.class.size(sectionWidth)
        case .logout:
            return Reusable.actionMenu.class.size(sectionWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch self.dataSource[section] {
        case .sectionHeader:
            return .init(top: 8, left: 16, bottom: 8, right: 16)
        case .actionMenu:
            return .init(top: 8, left: 16, bottom: 8, right: 16)
        default:
            return .zero
        }
    }
}


import ReactorKit

extension AppMenuViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = AppMenuViewReactor
    
    func bind(reactor: Reactor) {
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected
            .map { indexPath in self.dataSource[indexPath] }
            .subscribe(onNext: { [weak self] item in
            })
            .disposed(by: self.disposeBag)

        self.collectionView.rx.setDelegate(self).disposed(by: self.disposeBag)
    }
}
