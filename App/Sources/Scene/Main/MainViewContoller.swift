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
import DropDown

class MainViewContoller: BaseViewController, HasDropDownMenu {
    
    private struct Reusable {
        static let card = ReusableCell<SubjectCardCell>()
    }
    
    private lazy var dataSource: RxCollectionViewSectionedReloadDataSource<MainViewSection> = RxCollectionViewSectionedReloadDataSource(configureCell: { _, collectionView, indexPath, item -> UICollectionViewCell in
        switch item {
        case .card(let reactor):
            let cell = collectionView.dequeue(Reusable.card, for: indexPath)
            cell.reactor = reactor
            return cell
        }
    })
    
    let dropDown = DropDown()
    
    private var aaa = DisposeBag()
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.card)
        return collectionView
    }()
 
    private let userProfileView: UIUserProfileView = {
        let button = UIUserProfileView(frame: .init(x: 0, y: 0, width: 36, height: 36))
        return button
    }()
    
    private let buildUpViewScreen: (_ subject: String, _ docId: String?) -> UIViewController
    
    init(
        reactor: Reactor,
        buildUpViewScreen: @escaping (_ subject: String, _ docId: String?) -> UIViewController
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
    override func setupNavigationBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.userProfileView)
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
        
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.listenSubjects }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.rx.viewWillAppear
            .map { _ in Reactor.Action.listenUserState }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.itemSelected
            .map { indexPath in self.dataSource[indexPath] }
            .subscribe(onNext: { [weak self] sectionItem in
                guard let self = self else { return }
                switch sectionItem {
                case .card(let reactor):
                    let subject = reactor.currentState.item.subject
                    let buildUpViewController = self.buildUpViewScreen(subject, nil)
                    self.navigationController?.pushViewController(buildUpViewController, animated: true)
                }
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        
        reactor.state.map { $0.signInError }
            .filterNil()
            .subscribe(onNext: { [weak self] error in
                self?.displaySignInError(error)
            })
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        // MARK: User
        reactor.state.map { $0.userPhotoURL }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                self.userProfileView.setImage(url: url)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.authProvider }
            .distinctUntilChanged()
            .map { $0?.icon }
            .bind(to: self.userProfileView.rx.providerImage)
            .disposed(by: self.disposeBag)

        
        self.userProfileView.rx.tapGestureEnded()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showDropDownMenu()
            })
            .disposed(by: self.disposeBag)
    }
    
    private func showDropDownMenu() {
        guard let reactor = self.reactor else { return }
        let dataSources = reactor.currentState.authDropDownDataSources
        
        self.showDropDown(
            dataSources: dataSources,
            anchorView: self.userProfileView,
            configIcon: { AuthDropDownItem.create(title: $0)?.icon },
            didSelected: {
                guard let selected = AuthDropDownItem.create(title: $0) else { return }
                    switch selected {
                    case .google:
                        self.performGoogleAccountLink(authSignin: { credential in
                            reactor.action.onNext(.signIn(credential))
                        })
                    case .logout:
                        reactor.action.onNext(.signOut)
                    }
            }
        )
    }
}


extension Firestore {
    enum Collection: String {
        case buildUp = "build_up"
    }
}
