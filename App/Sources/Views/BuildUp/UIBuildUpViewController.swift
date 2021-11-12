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
import JJFloatingActionButton
import DropDown

class UIBuildUpViewController: BaseViewController {
    
    private struct Reusable {
        static let question = ReusableCell<BuildUpQuestionCell>()
        static let checkChioce = ReusableCell<BuildUpChoiceCell>()
        static let like = ReusableCell<BuildUpLikeCell>()
        static let tag = ReusableCell<BuildUpTagCell>()
    }

    private struct Metrics {
        static let margin: CGFloat = 16
        static let floatingHeight: CGFloat = 56
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
        case .like(let reactor):
            let cell = collectionView.dequeue(Reusable.like, for: indexPath)
            cell.reactor = reactor
            return cell
        case .tags(let tags):
            let cell = collectionView.dequeue(Reusable.tag, for: indexPath)
            cell.configCell(tags: tags)
            return cell
        }
    })
    
    let dropDown: DropDown = {
        let dropDown = DropDown()
        return dropDown
    }()
    
    private let userProfileView: UIUserProfileView = {
        let button = UIUserProfileView(frame: .init(x: 0, y: 0, width: 36, height: 36))
        return button
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.checkChioce)
        collectionView.register(Reusable.question)
        collectionView.register(Reusable.tag)
        collectionView.register(Reusable.like)
        return collectionView
    }()
    
    private let nextButton: UIRoundedShadowButton = {
        let button = UIRoundedShadowButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = FontFamily.NotoSansCJKKR.medium.font(size: 20)
        button.fillColor = ColorName.primary.color

        return button
    }()
    
    private let floatingButton: JJFloatingActionButton = {
        let button = JJFloatingActionButton()
        button.buttonImage = Asset.floatingInfomation.image.withRenderingMode(.alwaysTemplate)
        button.buttonImageColor = .white
        button.buttonColor = ColorName.accent.color
        button.handleSingleActionDirectly = false
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
        self.view.addSubview(self.floatingButton)
        
        self.nextButton.layer.shadowOffset = .init(width: 0, height: 1)
        self.nextButton.layer.shadowColor = UIColor.black.cgColor
        
        self.collectionView.contentInset.bottom = Metrics.floatingHeight + self.view.safeAreaInsets.bottom + 16
        self.collectionView.contentInset.left = Metrics.margin
        self.collectionView.contentInset.right = Metrics.margin
        self.collectionView.contentInset.top = Metrics.margin
     }
    
    override func setupConstraints() {
        self.collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.floatingButton.snp.makeConstraints {
            $0.height.equalTo(Metrics.floatingHeight)
            $0.trailing.equalToSuperview().inset(Metrics.margin)
            $0.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-Metrics.margin)
        }
        
        self.nextButton.snp.makeConstraints {
            $0.bottom.equalTo(self.floatingButton)
            $0.height.equalTo(self.floatingButton)
            $0.trailing.equalTo(self.floatingButton.snp.leading).offset(-Metrics.margin)
            $0.leading.equalToSuperview().inset(Metrics.margin)
        }
    }
    
    override func setupNavigationBarItems() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.userProfileView)
        
    }
    
    @objc func back() {
        self.dismiss(animated: true)
    }
}


extension UIBuildUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionWidth = collectionView.sectionWidth(at: indexPath.section)
        let sectionHeight = collectionView.sectionHeight(at: indexPath.section)
        
        switch self.dataSource[indexPath] {
        case .like:
            return Reusable.like.class.size(sectionWidth)
        case .question(let q):
            return Reusable.question.class.size(sectionWidth, sectionHeight, question: q)
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
            
        case .questions, .tag, .like:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var inset: UIEdgeInsets = .zero
        
        switch self.dataSource[section] {
        case .questions:
            inset.bottom = Metrics.margin * 2
            return inset
        case .answers, .tag:
            inset.bottom = Metrics.margin
            return inset
        case .like:
            return inset
        }
    }
}

import ReactorKit

extension UIBuildUpViewController: ReactorKit.View, HasDisposeBag {
    typealias Reactor = UIBuildUpViewReactor
    
    func bind(reactor: Reactor) {
        self.floatingButton.addItem(
            title: "오탈자 및 문의하기",
            image: Asset.email.image
        ) { item in
            guard let doc = reactor.currentState.document else { return }
            self.contactDocument(RemoteConfigStore.shared.contactEmail, doc: doc)
        }

        let googleLoginItem = JJActionItem()
        googleLoginItem.titleLabel.text = "Google 로그인"
        googleLoginItem.imageView.image = Asset.google.image
        googleLoginItem.action = { [weak self] _ in
            self?.performGoogleAccountLink()
        }
        
        reactor.state.map { $0.isLoggined }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isLoggined in
                guard let self = self else { return }
                if !isLoggined {
                    self.floatingButton.addItem(googleLoginItem)
                } else {
                    self.floatingButton.removeItem(googleLoginItem)
                }
            })
            .disposed(by: self.disposeBag)
            
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.nextButton.rx.tap
            .map { _ in Reactor.Action.tapNext }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: self.collectionView.rx.items(dataSource: self.dataSource))
            .disposed(by: self.disposeBag)
        
        self.collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.signInError }
            .filterNil()
            .subscribe(onNext: { [weak self] error in
                self?.displaySignInError(error)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.userPhotoURL }
            .filterNil()
            .subscribe(onNext: { [weak self] url in
                guard let self = self else { return }
                self.userProfileView.setImage(url: url)
            })
            .disposed(by: self.disposeBag)
        
        reactor.state.map { $0.authProvider }
            .filterNil()
            .map { $0.icon }
            .subscribe(onNext: { [weak self] image in
                self?.userProfileView.providerImage = image
            })
            .disposed(by: self.disposeBag)

        
        
        self.userProfileView.rx.tapGestureEnded()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showSignProviderDropDown(
                    anchorView: self.userProfileView,
                    dataSources: [AuthProvider.google],
                    didSelected: { [weak self] provider in
                        guard let self = self else { return }
                        guard let provider = provider else { return }
                        switch provider {
                        case .google:
                            self.performGoogleAccountLink()
                        }
                    }
                )
            })
            .disposed(by: self.disposeBag)
    }
}

